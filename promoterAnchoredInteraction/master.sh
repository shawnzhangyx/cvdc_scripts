###
Rscript extract_active_genes.r
intersectBed -a ../../data/annotation/hg19_10k_tiling_bin.bed -b ../../analysis/promoterAnchoredInteractions/genes_rpkm_max_gt1.tss.bed -wo > ../../analysis/promoterAnchoredInteractions/genes_rpkm_max_gt1.tss.overlap.txt
# find 10kb bins that overlap active genes
sort -k1,1 -k2,2n -k7,7 -u ../../analysis/promoterAnchoredInteractions/genes_rpkm_max_gt1.tss.overlap.txt > ../../analysis/promoterAnchoredInteractions/genes_rpkm_max_gt1.tss.overlap.unique.txt
cut -f 1-3 ../../analysis/promoterAnchoredInteractions/genes_rpkm_max_gt1.tss.overlap.unique.txt |uniq > ../../analysis/promoterAnchoredInteractions/10k_bins.overlap_active_genes.txt
# separate bins into chromosmes
mkdir ../../analysis/promoterAnchoredInteractions/10k_bins
for chr in {1..22} X Y;do
  grep chr${chr} ../../analysis/promoterAnchoredInteractions/10k_bins.overlap_active_genes.txt > ../../analysis/promoterAnchoredInteractions/10k_bins/${chr}_bins.txt
  done

# find significant promoter interactions 
mkdir ../../analysis/promoterAnchoredInteractions/raw_local_sig_tests
for chr in {1..22} X; do 
  for sample in $(cat ../../data/hic/meta/names.txt);do
  echo $chr $sample
  Rscript promoter_anchored.local_interaction.r ../../data/hic/matrix/$sample/${chr}_10000.txt ../../analysis/promoterAnchoredInteractions/raw_local_sig_tests/${sample}.${chr}.txt ../../analysis/promoterAnchoredInteractions/10k_bins/${chr}_bins.txt
  done
done
