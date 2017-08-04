pushd ../../data/ctcf/
for day in 00 02 07 15; do
  bamCoverage --bam bam/CTCF_D${day}_merged.bam --outFileFormat bigwig --outFileName bigWig/CTCF_D${day}_merged.rpkm.bw --binSize 25 --numberOfProcessors 4 --normalizeUsingRPKM &
  done

