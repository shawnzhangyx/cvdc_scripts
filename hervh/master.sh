mkdir ../../analysis/hervh
#cd ../../analysis/hervh

## merge herv sequence. 
bash merge_hervh_seq.sh
## quantify the RNA-seq signal on the HERVH sequences. 
bash HERVH.all_gene.bigWigOverBed.sh 
Rscript combineBW.output.sorted_beds.r
## quantify the RNA-seq signal based on the featureCounts not the bigWig. 
awk -v OFS="\t" '{print $4,$1,$2,$3,$6}' hervh.merged.strand.bed > hervh.merged.strand.saf
bams=../../data/rnaseq/rerun/bam/RZY6*.bam
featureCounts -a hervh.merged.strand.saf -o rnaseq/hervh.merged.rnaseq.counts $bams -F SAF -T 8


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


### to test if high transcription in general correlate with TAD boundary formation.
Rscript geneProfile.convert_d00_rnaseq_to_rpkm_bed.r
cd ../../analysis/hervh/
## find the nearest distance to CTCF peaks. 
bedtools closest -a <(awk -v OFS="\t" '{if ($5=="+"){print $1,$2-1000,$2,$4,$5 } else {print $1,$3,$3+1000,$4,$5} }'  D00.rna_seq.ranked_by_rpkm.v2.bed |sort -k1,1 -k2,2n ) -b ../../data/tfChIPseq/peaks/CTCF_D00/pooled/trurep_peaks.filtered.narrowPeak -d > all_genes.TSSs.dist.CTCF_peaks.txt

bedtools closest -a <(awk -v OFS="\t" '{if ($5=="+"){print $1,$3,$3+1000,$4,$5 } else {print $1,$2-1000,$2,$4,$5} }'  D00.rna_seq.ranked_by_rpkm.v2.bed |sort -k1,1 -k2,2n ) -b ../../data/tfChIPseq/peaks/CTCF_D00/pooled/trurep_peaks.filtered.narrowPeak -d > all_genes.TESs.dist.CTCF_peaks.txt




## generate the ChIP-seq profile on HERVH sequences 
bash HERVH.chipseq.bigWigOverBed.sh
Rscript calculate_chipseq_enrichment.r
bash generate_profile_brackets.sh
bash generate_profile.sh
bash generate_profile_brackets.final.sh

## HERVH regulated genes. 
#intersectBed -a <(awk -v OFS="\t" '{print $1,$2-50000,$3+50000,$4,$5}' hervh.dynamicBoundaries.for_deeptools.bed)  -b ../../analysis/di_tads/tad_di/D00_Rep1.TAD.bed -wo > hervh_regulated_gene_TADs/hervh.dyn.overlap.TADs.txt
intersectBed -a <(awk -v OFS="\t" '{print $1,$2-50000,$3+50000,$4,$5}' hervh.dynamicBoundaries.for_deeptools.bed)  -b ../../analysis/di_tads.10k.2M/di_tads/D00_HiC_Rep1.10000.200.DI.bedGraph.TAD.bed -wo > hervh_regulated_gene_TADs/hervh.dyn.overlap.TADs.v2.txt

Rscriopt split_hervh_TAD_boundary.r
# intersect gene TSS with the 5p and 3p boundary 
intersectBed -a hervh_regulated_gene_TADs/5p_TAD.bed -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -wo > hervh_regulated_gene_TADs/5p_TAD.overlap_genes.txt
intersectBed -a hervh_regulated_gene_TADs/3p_TAD.bed -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -wo > hervh_regulated_gene_TADs/3p_TAD.overlap_genes.txt
# remove the HERVH overlapped transcripts
intersectBed -a <(cut -f 4-7 hervh_regulated_gene_TADs/5p_TAD.overlap_genes.txt) -b hervh.dynamicBoundaries.for_deeptools.bed -v > hervh_regulated_gene_TADs/5p_TAD.overlap_genes.no_hervh.txt
intersectBed -a <(cut -f 4-7 hervh_regulated_gene_TADs/3p_TAD.overlap_genes.txt) -b hervh.dynamicBoundaries.for_deeptools.bed -v > hervh_regulated_gene_TADs/3p_TAD.overlap_genes.no_hervh.txt
# keep only the unique genes. 
intersect_5p_3p_genes.edger.r


Rscript analyze_hervh_5p_3p_TAD.genes.r


## liftover hervh locus to mouse 
mkdir ../../analysis/hervh/liftover2mm10
awk -v OFS="\t" '{print $1,$2-20000,$3+20000}' hervh.dynamicBoundaries.for_deeptools.bed > liftover2mm10/hervh.dynamicBoundaries.ext20k.bed

# plot DI
overlap_DI.sh
Rscript plotDI.profile.dyn.dixon.etal.r
Rscript plotDI.profile.dyn.nondyn.tile.r
Rscript plotDI.profile.iPSC.r
Rscript plotDI.profile.all_gene.r

## HERVH evolution analysis. 
Rscript analyze_ltr_seq.r
# liftover to chimp. 
~/software/ucsc/liftOver hervh.sorted_rnaseq.name.bed ~/software/ucsc/hg19ToPanTro5.over.chain.gz multi_seq_aln/HERVH-int.liftover.PanTro5.txt multi_seq_aln/HERVH-int.liftover.PanTro5.txt.unmapped -minMatch=0.1
~/software/ucsc/liftOver multi_seq_aln/5P_LTRs.Human.name.bed ~/software/ucsc/hg19ToPanTro5.over.chain.gz multi_seq_aln/5P_LTRs.liftover.PanTro5.bed multi_seq_aln/5P_LTRs.liftover.PanTro5.bed.unmapped -minMatch=0.1
