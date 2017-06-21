pushd ../../analysis/hiccup_loops/
awk -v OFS="\t" '{if(NR==1)print $0,"sample"}'  D00_HiC_Rep1.loop/merged_loops > combined_loops.raw.sorted.txt
for file in $(ls D*.loop/merged_loops); do
  awk -v OFS="\t" -v name=${file%.loop\/merged_loops} '{ if(NR>1) print $0,name}' $file 
done |sort --parallel=4 -k1,1 -k2,2n -k3,3n -k5,5n -k6,6n - >> combined_loops.raw.sorted.txt
# combine nearby loops. 
Rscript process_loops.r
# generate Juicer format loops for visualization
awk -v FS="\t" -v OFS='\t' '{ if (NR==1) {print $2,$3,$4,$5,$6,$7,"color"} else {print $2,$3,$4,$5,$6,$7,"0,255,255"} }' loops_merged_across_samples.tab > loops_merged_across_samples.juicer

# generate loop anchors
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $2,$3,$4}' loops_merged_across_samples.tab > loops_anchor1.bed
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $5,$6,$7}' loops_merged_across_samples.tab > loops_anchor2.bed
# SAF 
cat loops_anchor1.bed loops_anchor2.bed |sort -u > loop_anchors.uniq.bed 
awk -v OFS='\t' '{print NR,$1,$2,$3,"-"}' loop_anchors.uniq.bed > loop_anchors.saf

## intersect anchors with other genomic features.

## extract the interaction frequencies for the loops.
bash extractInteractions.sh
Rscript call_dynamic_loops_edgeR.r
Rscript cluster_all_loops.r
Rscript cluster_dynamic_loops.r
## overlap features to loops and count the reads over features
bash overlap_anchors_to_features.sh
bash count_chip_reads_anchor.sh
Rscript normalize_anchor_chip_reads.r

