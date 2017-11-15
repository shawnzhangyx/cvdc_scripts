pushd ../../data/rnaseq/lncRNA/
featureCounts -a ../../annotation/FANTOM_CAT.lv3_robust.all_lncRNA.gtf -o output.counts \
  ../bams/rnaseq_D00_Rep1.bam \
  ../bams/rnaseq_D00_Rep2.bam \
  ../bams/rnaseq_D02_Rep1.bam \
  ../bams/rnaseq_D02_Rep2.bam \
  ../bams/rnaseq_D05_Rep1.bam \
  ../bams/rnaseq_D05_Rep2.bam \
  ../bams/rnaseq_D07_Rep1.bam \
  ../bams/rnaseq_D07_Rep2.bam \
  ../bams/rnaseq_D15_Rep1.bam \
  ../bams/rnaseq_D15_Rep2.bam \
  ../bams/rnaseq_D80_Rep1.bam \
  ../bams/rnaseq_D80_Rep2.bam \
  -F GTF -T 8 -t exon -g gene_id 
  
