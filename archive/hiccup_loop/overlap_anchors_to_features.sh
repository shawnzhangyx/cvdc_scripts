pushd  ../../analysis/hiccup_loops/
outdir=overlap_anchors_to_features
mkdir -p $outdir
## intersect with all merged features
chipdir=../../data/chipseq/merged_peaks
echo -e "chr\tstart\tend\tCTCF\tATAC\tH3K4me1\tH3K4me3\tH3K27me3\tH3K27ac\tTSS" |tee \
$outdir/all_genomic_bins.features.txt $outdir/anchor.all_features.txt


intersectBed -a anchors/anchors.uniq.30k.bed -b ../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.bed -c |
  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c |
  intersectBed -a - -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -c \
  >> $outdir/anchor.all_features.txt


intersectBed -a /mnt/silencer2/home/yanxiazh/annotations/hg19/hg19_10k_tiling_bin.bed -b ../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.bed -c |
  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c |
  intersectBed -a - -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -c \
  >> $outdir/all_genomic_bins.features.txt

### overlap with individual marks.

intersectBed -b ../../data/atac/peaks/atac_merged_peaks.bed -a anchors/anchors.uniq.30k.bed -loj > $outdir/anchor.atac_merged_peaks.txt
intersectBed -b ../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.bed -a anchors/anchors.uniq.30k.bed -loj > $outdir/anchor.CTCF_merged_peaks.txt

for mark in H3K4me1 H3K4me3 H3K27ac H3K27me3; do
intersectBed -b $chipdir/${mark}_merged_peaks.bed -a anchors/anchors.uniq.30k.bed -loj > $outdir/anchor.${mark}_merged_peaks.txt
done
intersectBed -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -a anchors/anchors.uniq.30k.bed -loj > $outdir/anchor.gene_tss.txt
sort -k1,1 -k2,2n -k7,7 -u $outdir/anchor.gene_tss.txt > $outdir/anchor.gene_tss.unique.txt

### overlap with each stage. 
chippeak=../../data/chipseq/peaks/
mark=H3K27me3
for mark in H3K27me3 H3K27ac H3K4me1 H3K4me3; do
  echo -e "chr\tstart\tend\tD00\tD02\tD05\tD07\tD15\tD80" \
  > $outdir/anchor.${mark}.stages.txt
  cmd="cat anchors/anchors.uniq.30k.bed "
  for file in $( ls $chippeak/${mark}*/pooled/trurep_peaks.filtered.narrowPeak); do
    cmd+="| intersectBed -a - -b $file -c "
    done
  cmd+=">> $outdir/anchor.${mark}.stages.txt"
  bash -c "$cmd"
  done

  echo -e "chr\tstart\tend\tD00\tD02\tD05\tD07\tD15\tD80" \
  > $outdir/anchor.atac.stages.txt
  cmd="cat anchors/anchors.uniq.30k.bed "
  for file in $( ls ../../data/atac/peaks/*.truepeak.filtered.narrowPeak); do
    cmd+="| intersectBed -a - -b $file -c "
    done
  cmd+=">> $outdir/anchor.atac.stages.txt"
  bash -c "$cmd"


## overlap anchors to compartment AB
#D15 first
# intersectBed -a anchors/anchors.uniq.30k.bed -b ../../analysis/ab_compartments/pc1_data/combined.matrix -wo > overlap_anchors_to_features/anchors.compartments.txt


