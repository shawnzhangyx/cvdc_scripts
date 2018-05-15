mkdir ../../analysis/hervh
#cd ../../analysis/hervh

## merge herv sequence. 
bash merge_hervh_seq.sh
bash featureCounts.sh
Rscript combineBW.r

## find the motif 
bash find_motifs_hervh.sh
## plot the distance of HERVH to TAD boundary 
bedtools closest -a <(sort -k1,1 -k2,2n hervh.sorted_rnaseq.bed) -b ../tads/tad_boundary/D00.boundary.bed -d > hervh.dist.tad_boundary.txt
Rscript plotHervh.dist_tad_boundary.r

## plot the insulation score. 
mkdir insulation
for sample in $(cat ../../data/hic/meta/names.txt); do
  intersectBed -a hervh.ext500k.bed -b ../../data/hic/insulation/${sample}.ins.is500001.ids200001.bedGraph -wo > insulation/${sample}.insulation.txt 
  done


Rscript plot_insulation_score.r

## get the closest distance of TSSs to CTCF binding. 
bedtools closest -a <(sort -k1,1 -k2,2n hervh.sorted_rnaseq.bed) -b ../../data/tfChIPseq/peaks/CTCF_D00/pooled/trurep_peaks.filtered.narrowPeak -d > hervh.dist.CTCF_peaks.txt
bedtools closest -a <(sort -k1,1 -k2,2n D00.rna_seq.ranked_by_rpkm.bed) -b ../../data/tfChIPseq/peaks/CTCF_D00/pooled/trurep_peaks.filtered.narrowPeak -d > TSSs.dist.CTCF_peaks.txt

