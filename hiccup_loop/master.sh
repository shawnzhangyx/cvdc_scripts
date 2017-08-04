pushd ../../data/hic/loops/
outdir=../../../analysis/hiccup_loops/
awk -v OFS="\t" '{if(NR==1)print $0,"sample"}'  D00_HiC_Rep1.loop/merged_loops > $outdir/combined_loops.raw.sorted.txt
for file in $(ls D*.loop/merged_loops); do
  awk -v OFS="\t" -v name=${file%.loop\/merged_loops} '{ if(NR>1) print $0,name}' $file
  done |sort --parallel=4 -k1,1 -k2,2n - >> $outdir/combined_loops.raw.sorted.txt
cd ../../../analysis/hiccup_loops/
echo -e "$(head -n 1 combined_loops.raw.sorted.txt)\tgrp1\tgrp2" > combined_loops.grouped.txt
awk -v OFS="\t" 'function abs(v) {return v < 0 ? -v : v} {if ( abs($2-pre) >30000) { pre=$2;grp=grp+1;} print $0,grp}' combined_loops.raw.sorted.txt | tail -n +2 | sort --parallel=4 -k4,4 -k5,5n |\
awk -v OFS="\t" 'function abs(v) {return v < 0 ? -v : v} {if ( abs($5-pre) >30000) { pre=$5;grp=grp+1;} print $0,grp}' >> combined_loops.grouped.txt 

# combine nearby loops.
Rscript merge_loops_across_stages.r

# expand the loop to 30kb region
echo -e "chr1\tx1\ty1" > combined_loops.uniq.30k.txt
tail -n +2 combined_loops.uniq.txt | awk -v OFS="\t" '{for (i=-10000;i<=10000;i+=10000) { for (j=-10000;j<=10000;j+=10000) 
  { print $1,$2+i,$5+j}}}' >> combined_loops.uniq.30k.txt


