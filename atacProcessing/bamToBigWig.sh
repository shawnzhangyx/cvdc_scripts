pushd ../../data/atac

for day in 00 02 05 07 15 80; do
#  bamCoverage --bam bam/CTCF_D${day}_merged.bam --outFileFormat bigwig --outFileName bigWig/CTCF_D${day}_merged.rpkm.bw --binSize 25 --numberOfProcessors 4 --normalizeUsingRPKM &
samtools index bams/D${day}_1_sorted_nodup-chrM.30.bam &
samtools index bams/D${day}_2_sorted_nodup-chrM.30.bam &
done 
wait 

for day in 00 02 05 07 15 80; do
bamCoverage --bam bams/D${day}_1_sorted_nodup-chrM.30.bam --outFileFormat bigwig --outFileName bigWig/ATAC_D${day}_1.rpkm.bw --binSize 25 --numberOfProcessors 4 --normalizeUsingRPKM &
bamCoverage --bam bams/D${day}_2_sorted_nodup-chrM.30.bam --outFileFormat bigwig --outFileName bigWig/ATAC_D${day}_2.rpkm.bw --binSize 25 --numberOfProcessors 4 --normalizeUsingRPKM &
done


