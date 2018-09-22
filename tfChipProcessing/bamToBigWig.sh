pushd ../../data/tfChIPseq

for day in 00 02 05 07 15; do
#  bamCoverage --bam bam/CTCF_D${day}_merged.bam --outFileFormat bigwig --outFileName bigWig/CTCF_D${day}_merged.rpkm.bw --binSize 25 --numberOfProcessors 4 --normalizeUsingRPKM &
samtools index bam/Input_D${day}_Rep1.bam &
samtools index bam/Input_D${day}_Rep2.bam &
done 
wait 
for day in 00 02 05 07 15; do
bamCoverage --bam bam/Input_D${day}_Rep1.bam --outFileFormat bigwig --outFileName bigWig/Input_D${day}_Rep1.rpkm.bw --binSize 25 --numberOfProcessors 4 --normalizeUsingRPKM &
bamCoverage --bam bam/Input_D${day}_Rep2.bam --outFileFormat bigwig --outFileName bigWig/Input_D${day}_Rep2.rpkm.bw --binSize 25 --numberOfProcessors 4 --normalizeUsingRPKM &

  done

day=80
#bamCoverage --bam bam/CTCF_D${day}_rep1.bam --outFileFormat bigwig --outFileName bigWig/CTCF_D${day}_rep1.rpkm.bw --binSize 25 --numberOfProcessors 4 --normalizeUsingRPKM &
bamCoverage --bam bam/Input_D${day}_Rep1.bam --outFileFormat bigwig --outFileName bigWig/Input_D${day}_Rep1.rpkm.bw --binSize 25 --numberOfProcessors 4 --normalizeUsingRPKM &


bamCoverage --bam bam/Input.for_cohesin.D00.bam --outFileFormat bigwig --outFileName bigWig/Input.for_cohesin.D00.rpkm.bw --binSize 25 --normalizeUsingRPKM &
bamCoverage --bam bam/Input.for_cohesin.D00.q0.bam --outFileFormat bigwig --outFileName bigWig/Input.for_cohesin.D00.q0.rpkm.bw --binSize 25 --normalizeUsingRPKM &

bamCoverage --bam bam/SMC3.ab9263.D00.bam --outFileFormat bigwig --outFileName bigWig/SMC3.ab9263.D00.rpkm.bw --binSize 25 --normalizeUsingRPKM &
bamCoverage --bam bam/SMC3.ab9263.D00.bam --outFileFormat bigwig --outFileName bigWig/SMC3.ab9263.D00.rpkm.ext300.bw --binSize 25 --normalizeUsingRPKM --extendReads 300 &
bamCoverage --bam bam/SMC3.ab9263.D00.q0.bam --outFileFormat bigwig --outFileName bigWig/SMC3.ab9263.D00.q0.rpkm.bw --binSize 25 --normalizeUsingRPKM &


bamCoverage --bam bam/ENCODE.H1.POLR2A.bam --outFileFormat bigwig --outFileName bigWig/ENCODE.H1.POLR2A.rpkm.bw --binSize 25 --normalizeUsingRPKM &
bamCoverage --bam bam/ENCODE.H1.POLR2A.bam --outFileFormat bigwig --outFileName bigWig/ENCODE.H1.POLR2A.rpkm.ext300.bw --binSize 25 --normalizeUsingRPKM --extendReads 300 &

