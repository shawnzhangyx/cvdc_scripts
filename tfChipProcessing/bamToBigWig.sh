pushd ../../data/tfChIPseq
for day in 00 02 07 15; do
  bamCoverage --bam bam/CTCF_D${day}_merged.bam --outFileFormat bigwig --outFileName bigWig/CTCF_D${day}_merged.rpkm.bw --binSize 25 --numberOfProcessors 4 --normalizeUsingRPKM &
  done

day=80
bamCoverage --bam bam/CTCF_D${day}_rep1.bam --outFileFormat bigwig --outFileName bigWig/CTCF_D${day}_rep1.rpkm.bw --binSize 25 --numberOfProcessors 4 --normalizeUsingRPKM &

