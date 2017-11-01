pushd  ../../analysis/customLoops/
## overlap the anchor with GWAS catalog. 
awk -v FS='\t' -v OFS='\t' '{print $2,$3,$4,$1,$5}' ../../data/gWAS/GWAS_Catolog_hg19.txt > gWAS/GWAS_Catolog_hg19.bed
intersectBed -a anchors/anchors.uniq.30k.bed -b gWAS/GWAS_Catolog_hg19.bed -wo > gWAS/gwas_overlaped.txt
mergeBed -i <(sort -k1,1 -k2,2n anchors/anchors.uniq.30k.bed) > gWAS/anchors.merged.bed

intersectBed -a gWAS/anchors.clusters2-5.bed -b gWAS/GWAS_Catolog_hg19.bed -wo > gWAS/gwas_overlaped.clusters2-5.txt
intersectBed -a gWAS/anchors.clusters3-5.bed -b gWAS/GWAS_Catolog_hg19.bed -wo > gWA/gwas_overlaped.clusters3-5.txt

mergeBed -i <(sort -k1,1 -k2,2n gWAS/anchors.clusters2-5.bed ) > gWAS/anchors.clusters2-5.merged.bed
mergeBed -i <(sort -k1,1 -k3,3n gWAS/anchors.clusters3-5.bed ) > gWAS/anchors.clusters3-5.merged.bed

### first overlap the loop anchors with ATAseq peaks. 
intersectBed -a ../../data/atac/peaks/atac_merged_peaks.bed -b gWAS/anchors.clusters2-5.bed > gWAS/anchors.clusters2-5.ATAC.bed
intersectBed -a ../../data/atac/peaks/atac_merged_peaks.bed -b gWAS/anchors.clusters3-5.bed > gWAS/anchors.clusters3-5.ATAC.bed
intersectBed -a ../../data/atac/peaks/atac_merged_peaks.bed -b gWAS/anchors.nondynamic.bed > gWAS/anchors.nondynamic.ATAC.bed

### overlap the loop anchors with stage-wise ATACseq peaks 
intersectBed -a ../../data/atac/peaks/atac_merged_peaks.bed -b ../../data/atac/peaks/D00.ATAC.truepeak.filtered.narrowPeak -v | intersectBed -a - -b gWAS/anchors.clusters2-5.bed > gWAS/anchors.clusters2-5.ATAC2-5.bed

intersectBed -a ../../data/atac/peaks/atac_merged_peaks.bed -b ../../data/atac/peaks/D00.ATAC.truepeak.filtered.narrowPeak -v |intersectBed -a - -b ../../data/atac/peaks/D02.ATAC.truepeak.filtered.narrowPeak -v | intersectBed -a - -b gWAS/anchors.clusters3-5.bed > gWAS/anchors.clusters3-5.ATAC3-5.bed


### overlap the anchor ATAC-seq peaks with GWAS catalog. 
awk -v FS='\t' -v OFS='\t' '{print $2,$3,$4,$1,$5,$6}' ../../data/gWAS/GWAS_Catolog.LD.SNP.hg19.txt > gWAS/GWAS_Catolog.LD.SNP.hg19.bed
intersectBed -a gWAS/anchors.clusters2-5.ATAC.bed -b gWAS/GWAS_Catolog.LD.SNP.hg19.bed -wo > gWAS/gwas_overlaped.clusters2-5.ATAC.txt
intersectBed -a gWAS/anchors.clusters3-5.ATAC.bed -b gWAS/GWAS_Catolog.LD.SNP.hg19.bed -wo > gWAS/gwas_overlaped.clusters3-5.ATAC.txt
intersectBed -a gWAS/anchors.nondynamic.ATAC.bed -b gWAS/GWAS_Catolog.LD.SNP.hg19.bed -wo > gWAS/gwas_overlaped.nondynamic.ATAC.txt


intersectBed -a gWAS/anchors.clusters2-5.ATAC2-5.bed -b gWAS/GWAS_Catolog.LD.SNP.hg19.bed -wo > gWAS/gwas_overlaped.clusters2-5.ATAC2-5.txt
intersectBed -a gWAS/anchors.clusters3-5.ATAC3-5.bed -b gWAS/GWAS_Catolog.LD.SNP.hg19.bed -wo > gWAS/gwas_overlaped.clusters3-5.ATAC3-5.txt


### calculate significant snp. 
cd ../../scripts/customLoops/
Rscript gWAS_calc_significance.LD_SNP.r anchors.clusters2-5.ATAC.bed gwas_overlaped.clusters2-5.ATAC.txt LD_SNP.clusters2-5.ATAC.out
Rscript gWAS_calc_significance.LD_SNP.r anchors.clusters3-5.ATAC.bed gwas_overlaped.clusters3-5.ATAC.txt LD_SNP.clusters3-5.ATAC.out
Rscript gWAS_calc_significance.LD_SNP.r anchors.nondynamic.ATAC.bed gwas_overlaped.nondynamic.ATAC.txt LD_SNP.nondynamic.ATAC.out


#############
## subset with expressed genes gt day 2. 
intersectBed -a ../../data/atac/peaks/atac_merged_peaks.bed -b gWAS/anchors_connect_to_expressed_gene_D2-80.txt > gWAS/anchors_connect_to_expressed_gene_D2-80.ATAC.bed
intersectBed -a gWAS/anchors_connect_to_expressed_gene_D2-80.ATAC.bed -b gWAS/GWAS_Catolog.LD.SNP.hg19.bed -wo > gWAS/gwas_overlap.anchors_connect_to_expressed_gene_D2-80.ATAC.txt
Rscript gWAS_calc_significance.LD_SNP.r anchors_connect_to_expressed_gene_D2-80.ATAC.bed gwas_overlap.anchors_connect_to_expressed_gene_D2-80.ATAC.txt LD_SNP.anchors_connect_to_expressed_gene_D2-80.ATAC.out


