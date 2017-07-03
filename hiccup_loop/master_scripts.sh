pushd ../../analysis/hiccup_loops/
awk -v OFS="\t" '{if(NR==1)print $0,"sample"}'  D00_HiC_Rep1.loop/merged_loops > combined_loops.raw.sorted.txt
for file in $(ls D*.loop/merged_loops); do
  awk -v OFS="\t" -v name=${file%.loop\/merged_loops} '{ if(NR>1) print $0,name}' $file 
done |sort --parallel=4 -k1,1 -k2,2n -k3,3n -k5,5n -k6,6n - >> combined_loops.raw.sorted.txt
# combine nearby loops. 
Rscript merge_loops_across_stages.r
# generate Juicer format loops for visualization
awk -v FS="\t" -v OFS='\t' '{ if (NR==1) {print $2,$3,$4,$5,$6,$7,"color"} else {print $2,$3,$4,$5,$6,$7,"0,255,255"} }' loops_merged_across_samples.uniq.tab > loops_merged_across_samples.uniq.juicer
awk -v FS="\t" -v OFS='\t' '{ if (NR==1) {print $1,$2,$3,$4,$5,$6,"color"} else {print $1,$2,$3,$4,$5,$6,"0,255,255"} }' loops_merged_across_samples.uniq.replicated.tab > loops_merged_across_samples.uniq.replicated.juicer



# generate loop anchors
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $2,$3,$4}' loops_merged_across_samples.uniq.tab > loops_anchor1.bed
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $5,$6,$7}' loops_merged_across_samples.uniq.tab > loops_anchor2.bed
cat loops_anchor1.bed loops_anchor2.bed |sort -u > loop_anchors.uniq.bed 
awk -v OFS="\t" '{print $1,$2-10000,$3+10000}' loop_anchors.uniq.bed > loop_anchors.uniq.30k.bed
intersectBed -a loop_anchors.uniq.30k.bed -b <(cat loops_anchor1.bed loops_anchor2.bed) -c |sort -k4,4nr > loop_anchors.uniq.30k.num_loops.txt

# generate loop anchors of replicated loops
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $1,$2,$3}' loops_merged_across_samples.uniq.replicated.tab > replicated_loops/loops_anchor1.bed
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $4,$5,$6}' loops_merged_across_samples.uniq.replicated.tab > replicated_loops/loops_anchor2.bed
cat replicated_loops/loops_anchor1.bed replicated_loops/loops_anchor2.bed |sort -u > replicated_loops/loop_anchors.uniq.bed
awk -v OFS="\t" '{print $1,$2-10000,$3+10000}' replicated_loops/loop_anchors.uniq.bed > replicated_loops/loop_anchors.uniq.30k.bed
intersectBed -a replicated_loops/loop_anchors.uniq.30k.bed -b <(cat replicated_loops/loops_anchor1.bed replicated_loops/loops_anchor2.bed) -c |sort -k4,4nr > replicated_loops/loop_anchors.uniq.30k.num_loops.txt


# generate SAF for anchors. 
#awk -v OFS='\t' '{print NR,$1,$2,$3,"-"}' loop_anchors.uniq.bed > loop_anchors.saf

## intersect anchors with other genomic features.

## extract the interaction frequencies for the loops.
bash stra_extractInteraction.sh
Rscript call_dynamic_loops_edgeR.r
Rscript loop_combine_cpb_edger_info.r
Rscript cluster_all_loops.r
Rscript cluster_dynamic_loops.r
## overlap features to loops and count the reads over features
bash overlap_anchors_to_features.sh
bash overlap_features_to_anchors.sh
bash count_chip_reads_anchor.sh
Rscript normalize_anchor_chip_reads.r

