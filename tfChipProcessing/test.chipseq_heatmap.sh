pushd ../../data/tfChIPseq/
touch test.bed
sort -k8,8nr peaks/GATA4_D05_Rep1/GATA4_D05_Rep1_peaks.narrowPeak  > test.bed 
computeMatrix reference-point -S \
              bigWig/GATA4_D02_Rep1.bw  \
              bigWig/GATA4_D02_Rep2.bw  \
              bigWig/GATA4_D05_Rep1.bw  \
              bigWig/GATA4_D05_Rep2.bw  \
              bigWig/GATA4_D07_Rep1.bw  \
              bigWig/GATA4_D07_Rep2.bw  \
              bigWig/GATA4_D15_Rep1.bw  \
              bigWig/GATA4_D15_Rep2.bw  \
              -R test.bed \
              --beforeRegionStartLength 5000 \
              --afterRegionStartLength 5000 \
              --skipZeros -o test.GATA4.gz

plotHeatmap -m test.GATA4.gz \
      -out GATA4.png


sort -k8,8nr peaks/TBX5_D05_Rep1/TBX5_D05_Rep1_peaks.narrowPeak  > test.bed
computeMatrix reference-point -S \
              bigWig/TBX5_D05_Rep1.bw  \
              bigWig/TBX5_D05_Rep2.bw  \
              bigWig/TBX5_D07_Rep1.bw  \
              bigWig/TBX5_D15_Rep1.bw  \
              bigWig/TBX5_D15_Rep2.bw  \
              -R test.bed \
              --beforeRegionStartLength 5000 \
              --afterRegionStartLength 5000 \
              --skipZeros -o test.TBX5.gz

plotHeatmap -m test.TBX5.gz \
      -out TBX5.png

atac=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/trackhub/hg19
sort -k8,8nr peaks/GATA4_D05_Rep1/GATA4_D05_Rep1_peaks.narrowPeak  > test.bed
computeMatrix reference-point -S \
              $atac/ATAC_D00.rpkm.bw  \
              $atac/ATAC_D02.rpkm.bw  \
              $atac/ATAC_D05.rpkm.bw  \
              $atac/ATAC_D07.rpkm.bw  \
              $atac/ATAC_D15.rpkm.bw  \
              $atac/ATAC_D80.rpkm.bw  \
              -R test.bed \
              --beforeRegionStartLength 5000 \
              --afterRegionStartLength 5000 \
              --skipZeros -o test.GATA4.ATAC.gz

plotHeatmap -m test.GATA4.ATAC.gz \
      -out GATA4.ATAC.png

sort -k8,8nr peaks/TBX5_D05_Rep1/TBX5_D05_Rep1_peaks.narrowPeak  > test.bed
computeMatrix reference-point -S \
              $atac/ATAC_D00.rpkm.bw  \
              $atac/ATAC_D02.rpkm.bw  \
              $atac/ATAC_D05.rpkm.bw  \
              $atac/ATAC_D07.rpkm.bw  \
              $atac/ATAC_D15.rpkm.bw  \
              $atac/ATAC_D80.rpkm.bw  \
              -R test.bed \
              --beforeRegionStartLength 5000 \
              --afterRegionStartLength 5000 \
              --skipZeros -o test.TBX5.ATAC.gz

plotHeatmap -m test.TBX5.ATAC.gz \
      -out TBX5.ATAC.png

