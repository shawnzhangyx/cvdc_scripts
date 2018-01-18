intersectBed -a <(sort -k8,8nr peaks/GATA4_D05_Rep1/GATA4_D05_Rep1_peaks.narrowPeak) -b ../atac/peaks/D05.ATAC.truepeak.filtered.narrowPeak -c > test/GATA4.chipseq.atac.overlap.txt
intersectBed -a <(sort -k8,8nr peaks/GATA4_D05_Rep1/GATA4_D05_Rep1_peaks.narrowPeak) -b ../atac/peaks/D05.ATAC.truepeak.filtered.narrowPeak -u |wc -l
#17252
intersectBed -a peaks/GATA4_D02_Rep1/GATA4_D02_Rep1_peaks.narrowPeak -b peaks/GATA4_D05_Rep1/GATA4_D05_Rep1_peaks.narrowPeak -u |wc -l #727
intersectBed -a peaks/GATA4_D02_Rep2/GATA4_D02_Rep2_peaks.narrowPeak -b peaks/GATA4_D05_Rep1/GATA4_D05_Rep1_peaks.narrowPeak -u |wc -l #620
intersectBed -a peaks/GATA4_D05_Rep2/GATA4_D05_Rep2_peaks.narrowPeak -b peaks/GATA4_D05_Rep1/GATA4_D05_Rep1_peaks.narrowPeak -u |wc -l #2
intersectBed -a peaks/GATA4_D07_Rep1/GATA4_D07_Rep1_peaks.narrowPeak -b peaks/GATA4_D05_Rep1/GATA4_D05_Rep1_peaks.narrowPeak -u |wc -l #23
intersectBed -a peaks/GATA4_D07_Rep2/GATA4_D07_Rep2_peaks.narrowPeak -b peaks/GATA4_D05_Rep1/GATA4_D05_Rep1_peaks.narrowPeak -u |wc -l #518
intersectBed -a peaks/GATA4_D15_Rep1/GATA4_D15_Rep1_peaks.narrowPeak -b peaks/GATA4_D05_Rep1/GATA4_D05_Rep1_peaks.narrowPeak -u |wc -l #1158
intersectBed -a peaks/GATA4_D15_Rep2/GATA4_D15_Rep2_peaks.narrowPeak -b peaks/GATA4_D05_Rep1/GATA4_D05_Rep1_peaks.narrowPeak -u |wc -l #312

#intersectBed -a <(sort -k8,8nr peaks/GATA4_D05_Rep1/GATA4_D05_Rep1_peaks.narrowPeak) -b ../atac/peaks/D05.ATAC.truepeak.filtered.narrowPeak -u |wc -l

intersectBed -a <(sort -k8,8nr peaks/TBX5_D05_Rep1/TBX5_D05_Rep1_peaks.narrowPeak) -b ../atac/peaks/D05.ATAC.truepeak.filtered.narrowPeak -c > test/TBX5.chipseq.atac.overlap.txt
intersectBed -a <(sort -k8,8nr peaks/TBX5_D05_Rep1/TBX5_D05_Rep1_peaks.narrowPeak) -b ../atac/peaks/D05.ATAC.truepeak.filtered.narrowPeak -u |wc -l

