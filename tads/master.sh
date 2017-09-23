pushd ../../analysis/tads/
mkidr arrowhead_tads anchors
cd arrowhead_tads
for name in 00 02 05 07 15 80; do 
ln ../../../data/hic/tads/D${name}_HiC_Rep1.tads/10000_blocks D$name.Rep1.10000_blocks
ln ../../../data/hic/tads/D${name}_HiC_Rep2.tads/10000_blocks D$name.Rep2.10000_blocks
done
cd ..
awk -v OFS="\t" '{if(NR==1)print $0,"sample"}'  arrowhead_tads/D00.Rep1.10000_blocks > combined_tads.raw.sorted.txt
for file in $(ls arrowhead_tads/D??.Rep?.10000_blocks); do
  awk -v OFS="\t" -v name=${file/arrowhead_tads\/} '{ if(NR>1) print $0,name}' $file
    done |sort --parallel=4 -k1,1 -k2,2n -k3,3n - >> combined_tads.raw.sorted.txt

echo -e "$(head -n 1 combined_tads.raw.sorted.txt)\tgrp1\tgrp2" > combined_tads.grouped.txt
awk -v OFS="\t" 'function abs(v) {return v < 0 ? -v : v} {if ( abs($2-pre) >50000) { pre=$2;grp=grp+1;} print $0,grp}' combined_tads.raw.sorted.txt | tail -n +2 | sort --parallel=4 -k1,1 -k3,3n |\
awk -v OFS="\t" 'function abs(v) {return v < 0 ? -v : v} {if ( abs($3-pre) >50000) { pre=$3;grp=grp+1;} print $0,grp}' >> combined_tads.grouped.txt

Rscript merge_tads_across_stages2.r

# mkdir -p anchors
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $1,$2 }' combined_tads.uniq.gt1.txt > anchors/anchor1.bed
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $1,$3 }' combined_tads.uniq.gt1.txt > anchors/anchor2.bed
cat anchors/anchor1.bed anchors/anchor2.bed |sort -u > anchors/anchors.uniq.bed
awk -v OFS="\t" '{print $1,$2-20000,$2+20000}' anchors/anchors.uniq.bed > anchors/anchors.uniq.40k.bed


bash -x overlap_anchors_to_features.sh
