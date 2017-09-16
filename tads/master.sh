pushd ../../analysis/tads/
mkidr arrowhead_tads 
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
    awk -v OFS="\t" 'function abs(v) {return v < 0 ? -v : v} {if ( abs($2-pre) >25000) { pre=$2;grp=grp+1;} print $0,grp}' combined_tads.raw.sorted.txt | tail -n +2 | sort --parallel=4 -k4,4 -k19,19n |\
    awk -v OFS="\t" 'function abs(v) {return v < 0 ? -v : v} {if ( abs($3-pre) >25000) { pre=$3;grp=grp+1;} print $0,grp}' >> combined_tads.grouped.txt

