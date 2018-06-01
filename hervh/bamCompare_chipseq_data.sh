for factor in H3K27ac H3K4me1 H3K27me3 H3K4me3; do
bamCompare --bamfile1 ../../data/chipseq/bams/${factor}_D00.merged.bam --bamfile2 ../../data/chipseq/bams/${factor}_D05.merged.bam \
  --binSize 200 --smoothLength 2000 \
  --outFileName chipseq_bam_D00-D05/${factor}.D00-D05.bamcompare.bw
  done

computeMatrix scale-regions -S \
  chipseq_bam_D00-D05/H3K4me3.D00-D05.bamcompare.bw \
  chipseq_bam_D00-D05/H3K4me1.D00-D05.bamcompare.bw \
  chipseq_bam_D00-D05/H3K27ac.D00-D05.bamcompare.bw \
  chipseq_bam_D00-D05/H3K27me3.D00-D05.bamcompare.bw \
  -R hervh.dynamicBoundaries.for_deeptools.bed \
  --regionBodyLength 10000 \
  --beforeRegionStartLength 200000 \
  --afterRegionStartLength  200000 \
  --averageTypeBins median \
  --skipZeros -o chipseq_bam_D00-D05/chipseq_bamcompare.mat.gz


  plotHeatmap -m chipseq_bam_D00-D05/chipseq_bamcompare.mat.gz \
      --sortRegions no \
      --colorList 'black, yellow' \
      -out chipseq_bam_D00-D05/chipseq_bamcompare.png
