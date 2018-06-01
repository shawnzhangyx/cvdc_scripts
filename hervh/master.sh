mkdir ../../analysis/hervh
#cd ../../analysis/hervh

## merge herv sequence. 
bash merge_hervh_seq.sh
## quantify the RNA-seq signal on the HERVH sequences. 
bash HERVH.all_gene.bigWigOverBed.sh 
Rscript combineBW.output.sorted_beds.r

## find the motif 
bash find_motifs_hervh.sh
## plot the distance of HERVH to TAD boundary 
bedtools closest -a <(sort -k1,1 -k2,2n hervh.sorted_rnaseq.bed) -b ../tads/tad_boundary/D00.boundary.bed -d > hervh.dist.tad_boundary.txt
Rscript plotHervh.dist_tad_boundary.r

## plot the insulation score. 
mkdir ../../analysis/hervh/insulation
for sample in $(cat ../../data/hic/meta/names.txt); do
  intersectBed -a hervh.ext500k.bed -b ../../data/hic/insulation/${sample}.ins.is500001.ids200001.bedGraph -wo > insulation/${sample}.insulation.txt 
  done


Rscript plot_insulation_score.r

## get the closest distance of TSSs to CTCF binding. 
bedtools closest -a <(sort -k1,1 -k2,2n hervh.sorted_rnaseq.bed) -b ../../data/tfChIPseq/peaks/CTCF_D00/pooled/trurep_peaks.filtered.narrowPeak -d > hervh.dist.CTCF_peaks.txt
bedtools closest -a <(sort -k1,1 -k2,2n D00.rna_seq.ranked_by_rpkm.bed) -b ../../data/tfChIPseq/peaks/CTCF_D00/pooled/trurep_peaks.filtered.narrowPeak -d > TSSs.dist.CTCF_peaks.txt


## generate the ChIP-seq profile on HERVH sequences 
bash HERVH.chipseq.bigWigOverBed.sh
Rscript calculate_chipseq_enrichment.r
bash generate_profile_brackets.sh
bash generate_profile.sh

## HERVH regulated genes. 
intersectBed -a <(awk -v OFS="\t" '{print $1,$2-50000,$3+50000,$4,$5}' hervh.dynamicBoundaries.for_deeptools.bed)  -b ../../analysis/di_tads/tad_di/D00_Rep1.TAD.bed -wo > hervh_regulated_gene_TADs/hervh.dyn.overlap.TADs.txt
Rscriopt split_hervh_TAD_boundary.r
intersectBed -a hervh_regulated_gene_TADs/5p_TAD.bed -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -wo > hervh_regulated_gene_TADs/5p_TAD.overlap_genes.txt
intersectBed -a hervh_regulated_gene_TADs/3p_TAD.bed -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -wo > hervh_regulated_gene_TADs/3p_TAD.overlap_genes.txt
intersectBed -a <(cut -f 4-7 hervh_regulated_gene_TADs/5p_TAD.overlap_genes.txt) -b hervh.dynamicBoundaries.for_deeptools.bed -v > hervh_regulated_gene_TADs/5p_TAD.overlap_genes.no_hervh.txt
intersectBed -a <(cut -f 4-7 hervh_regulated_gene_TADs/3p_TAD.overlap_genes.txt) -b hervh.dynamicBoundaries.for_deeptools.bed -v > hervh_regulated_gene_TADs/3p_TAD.overlap_genes.no_hervh.txt


Rscript analyze_hervh_5p_3p_TAD.genes.r


## liftover hervh locus to mouse 
mkdir ../../analysis/hervh/liftover2mm10
awk -v OFS="\t" '{print $1,$2-20000,$3+20000}' hervh.dynamicBoundaries.for_deeptools.bed > liftover2mm10/hervh.dynamicBoundaries.ext20k.bed


