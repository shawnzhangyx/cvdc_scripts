pushd  ../../analysis/tads/
outdir=overlap_tad_to_features
mkdir -p $outdir
## intersect with all merged features
chipdir=../../data/chipseq/merged_peaks

#for name in {D00,D80,gain}.{within,pre,pos}; do 
for name in {D00,D80}.unique; do

echo -e "chr\tstart\tend\tCTCF\tATAC\tH3K4me1\tH3K4me3\tH3K27me3\tH3K27ac\tTSS" |tee \
$outdir/${name}.all_features.txt

intersectBed -a stage_specific_tads/${name}.tads -b ../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.bed -c |
  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c |
  intersectBed -a - -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -c \
  >> $outdir/${name}.all_features.txt

### overlap with individual marks.

intersectBed -b ../../data/atac/peaks/atac_merged_peaks.bed -a stage_specific_tads/${name}.tads -loj > $outdir/${name}.atac_merged_peaks.txt
intersectBed -b ../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.bed -a stage_specific_tads/${name}.tads -loj > $outdir/${name}.CTCF_merged_peaks.txt

for mark in H3K4me1 H3K4me3 H3K27ac H3K27me3; do
intersectBed -b $chipdir/${mark}_merged_peaks.bed -a stage_specific_tads/${name}.tads -loj > $outdir/${name}.${mark}_merged_peaks.txt
done
intersectBed -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -a stage_specific_tads/${name}.tads -loj > $outdir/${name}.gene_tss.txt
sort -k1,1 -k2,2n -k7,7 -u $outdir/${name}.gene_tss.txt > $outdir/${name}.gene_tss.unique.txt

### overlap with each stage. 
chippeak=../../data/chipseq/peaks/
mark=H3K27me3
for mark in H3K27me3 H3K27ac H3K4me1 H3K4me3; do
  echo -e "chr\tstart\tend\t${name}\tD02\tD05\tD07\tD15\tD80" \
  > $outdir/${name}.${mark}.stages.txt
  cmd="cat stage_specific_tads/${name}.tads "
  for file in $( ls $chippeak/${mark}*/pooled/trurep_peaks.filtered.narrowPeak); do
    cmd+="| intersectBed -a - -b $file -c "
    done
  cmd+=">> $outdir/${name}.${mark}.stages.txt"
  bash -c "$cmd"
  done

  echo -e "chr\tstart\tend\t${name}\tD02\tD05\tD07\tD15\tD80" \
  > $outdir/${name}.atac.stages.txt
  cmd="cat stage_specific_tads/${name}.tads "
  for file in $( ls ../../data/atac/peaks/*.truepeak.filtered.narrowPeak); do
    cmd+="| intersectBed -a - -b $file -c "
    done
  cmd+=">> $outdir/${name}.atac.stages.txt"
  bash -c "$cmd"
done

## overlap anchors to compartment AB
#D15 first
# intersectBed -a ${name}.tads -b ../../analysis/ab_compartments/pc1_data/combined.matrix -wo > overlap_anchors_to_features/anchors.compartments.txt


