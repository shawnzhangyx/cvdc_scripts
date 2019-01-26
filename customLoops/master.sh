pushd ../../analysis/customLoops/
mkdir -p edgeR loops anchors figures figures/cluster_with_names/ clusters/ overlap_loopdomain_to_features/ APA_plots/ loop_control_distance_matched/

## call loops for each sample. 
qsub run_test.qs
bash post_process_loops.sh
bash combine_loops_per_sample.sh
## merge loops across stages. 
awk -v OFS="\t" '{if(NR==1)print $0,"sample"}'  loops_by_sample/D00_HiC_Rep1.loops > combined_loops.raw.sorted.txt
for file in $(ls loops_by_sample/D??_HiC_Rep?.loops); do
  awk -v OFS="\t" -v name=${file/loops_by_sample\/} '{ if(NR>1) print $0,name}' $file
  done |sort --parallel=4 -k1,1 -k2,2n -k3,3n - >> combined_loops.raw.sorted.txt
popd
Rscript merge_loops_across_stages.r

## convert loops to WashU format
awk -v OFS="\t" '{ if (NR>1){ print $1":"$2"-"$3,$4":"$5"-"$6,1 }}' combined_loops.uniq.gt1.juicer.txt > combined_loops.uniq.gt1.WashU.txt

bash straw_extractInteractions.sh
## call dynamic loops
call_dynamic_loops_edgeR.r
Rscript cluster_dynamic_loop.r
Rscript loop_combine_cpb_edger_info.r


# generate loop anchors
mkdir -p anchors
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $1,$2,$3 }' combined_loops.uniq.gt1.juicer.txt > anchors/anchor1.bed
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $4,$5,$6 }' combined_loops.uniq.gt1.juicer.txt > anchors/anchor2.bed
cat anchors/anchor1.bed anchors/anchor2.bed |sort -u > anchors/anchors.uniq.bed
awk -v OFS="\t" '{print $1,$2-10000,$3+10000}' anchors/anchors.uniq.bed > anchors/anchors.uniq.30k.bed
# generate multi-loop anchors. 
intersectBed -a anchors/anchors.uniq.30k.bed -b <(cat anchors/anchor1.bed anchors/anchor2.bed) -c |sort -k4,4nr > anchors/anchors.uniq.30k.num_loops.txt
Rscript prune_multi_loop_anchors.r 

#overlap features to anchors
bash overlap_anchors_to_features.sh
Rscript computeAnchor.featureCounts.r
Rscript mergeLoopFeatureMat.r

### make figures
for clu in {1..5}; do
Rscript plotLoop_eachCluster.r $clu &
done
Rscript plotNondynamicLoop.r


### determine loop category. 
Rscript calcLoopCategory2.r

### 
Rscript generate_background_loop_with_same_distance.r
bash overlap_control_anchor_to_features.sh



