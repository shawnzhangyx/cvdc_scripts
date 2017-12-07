pushd ../../analysis/tads/
## qsub arrowhead.qs

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
# merge tads across differnt stages. 
Rscript merge_tads_across_stages2.r

# generate the tad boundaries. 
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $1,$2 }' combined_tads.uniq.gt1.txt > anchors/anchor1.bed
awk -v FS="\t" -v OFS="\t" '{if (NR>1) print $1,$3 }' combined_tads.uniq.gt1.txt > anchors/anchor2.bed
cat anchors/anchor1.bed anchors/anchor2.bed |sort -u > anchors/anchors.uniq.bed
awk -v OFS="\t" '{print $1,$2-25000,$2+25000}' anchors/anchors.uniq.bed > anchors/anchors.uniq.50k.bed

# refine TAD by insulation
#bash -x straw_extractInteraction.sh
   # -> sum_tad_counts_each_sample.r

# refine TAD by scores. 
qsub calcTADscore.qs
Rscript merge_tad_score_across_stages.r
Rscript refine_tads_by_score.r


# separate TAD into categories.
#Rscript archive/refine_tads_by_insu.r
#Rscript archive/separate_dynamic_tads_into_categories.r

## overlap TAD and anchors to features
bash -x overlap_anchors_to_features.sh
bash -x overlap_tad_to_features.sh
Rscript computeTad.featureCounts.r
Rscript computeBoundary.featureCounts.r
Rscript plotTad_Features.r
Rscript plotBoundary_Features.r


