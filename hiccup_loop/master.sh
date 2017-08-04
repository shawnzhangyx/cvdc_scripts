cd  ../../data/hic/loops/
outdir=../../../analysis/hiccup_loops/
awk -v OFS="\t" '{if(NR==1)print $0,"sample"}'  D00_HiC_Rep1.loop/merged_loops > $outdir/combined_loops.raw.sorted.txt
for file in $(ls D*.loop/merged_loops); do
  awk -v OFS="\t" -v name=${file%.loop\/merged_loops} '{ if(NR>1) print $0,name}' $file
  done |sort --parallel=4 -k1,1 -k18,18n -k19,19n - >> $outdir/combined_loops.raw.sorted.txt
cd ../../../analysis/hiccup_loops/
echo -e "$(head -n 1 combined_loops.raw.sorted.txt)\tgrp1\tgrp2" > combined_loops.grouped.txt
awk -v OFS="\t" 'function abs(v) {return v < 0 ? -v : v} {if ( abs($18-pre) >25000) { pre=$18;grp=grp+1;} print $0,grp}' combined_loops.raw.sorted.txt | tail -n +2 | sort --parallel=4 -k4,4 -k19,19n |\
awk -v OFS="\t" 'function abs(v) {return v < 0 ? -v : v} {if ( abs($5-pre) >25000) { pre=$19;grp=grp+1;} print $0,grp}' >> combined_loops.grouped.txt 

cd - #scripts directory
# combine nearby loops.
Rscript merge_loops_across_stages.r
bash straw_extractInteraction.sh

cd - #analysis directory
# expand the loop to 30kb region
echo -e "chr1\tx1\ty1" > combined_loops.uniq.30k.txt
tail -n +2 combined_loops.uniq.txt | awk -v OFS="\t" '{for (i=-10000;i<=10000;i+=10000) { for (j=-10000;j<=10000;j+=10000) 
  { print $1,$2+i,$5+j}}}' >> combined_loops.uniq.30k.txt

# generate loop anchors
mkdir -p anchors
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $1,$2,$3 }' combined_loops.uniq.txt > anchors/anchor1.bed
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $4,$5,$6 }' combined_loops.uniq.txt > anchors/anchor2.bed
cat anchors/anchor1.bed anchors/anchor2.bed |sort -u > anchors/anchors.uniq.bed
awk -v OFS="\t" '{print $1,$2-10000,$3+10000}' anchors/anchors.uniq.bed > anchors/anchors.uniq.30k.bed
intersectBed -a anchors/anchors.uniq.30k.bed -b <(cat anchors/anchor1.bed anchors/anchor2.bed) -c |sort -k4,4nr > anchors/anchors.uniq.30k.num_loops.txt

# overlap features to anchors
bash overlap_anchors_to_features.sh
Rscript computeAnchor.featureCounts.r


## separate dynamic and non-dynamic loops;clustering.
mkdir -p loops
mkdir -p dynamic_clusters
cd - # scripts directory
Rscript loop_combine_cpb_edger_info.r
Rscript cluster_dynamic_loop.r
