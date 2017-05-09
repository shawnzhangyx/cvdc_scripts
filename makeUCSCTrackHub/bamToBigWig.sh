outdir=../../data/trackhub/hg19
atacdir=../../data/atac/bams/

for day in 00 02 05 07 15 80
  do
 # bamCoverage --bam $atacdir/D${day}_sorted_nodup.30.bam --outFileFormat bigwig --outFileName $outdir/ATAC_D${day}.bw --binSize 25 --numberOfProcessors 4 &
  bamCoverage --bam $atacdir/D${day}_sorted_nodup.30.bam --outFileFormat bigwig --outFileName $outdir/ATAC_D${day}.rpkm.bw --binSize 25 --numberOfProcessors 1 --normalizeUsingRPKM &

  done

chipdir=../../data/chipseq/bams
for day in 00 02 05 07 15 80
  do
  for mark in H3K27ac H3K27me3 H3K4me1 H3K4me3 Input #H3K9me3
    do 
      files=$(ls $chipdir/${mark}_D${day}_*.30.nodup.bam)
      echo $files
      # bamCoverage --bam $chipdir/${mark}_D${day}.merged.bam --outFileFormat bigwig --outFileName $outdir/${mark}_D${day}.bw --binSize 25 --numberOfProcessors 1
      bamCoverage --bam $chipdir/${mark}_D${day}.merged.bam --outFileFormat bigwig --outFileName $outdir/${mark}_D${day}.rpkm.bw --binSize 25 --numberOfProcessors 1  --normalizeUsingRPKM &
    done
  done

rnadir=../../data/rnaseq/bams
for day in 00 02 05 07 15 80
  do
  bamCoverage --bam $rnadir/rnaseq_D${day}.merged.bam --outFileFormat bigwig --outFileName $outdir/rnaseq_D${day}.rpkm.bw --binSize 25 --numberOfProcessors 4  --normalizeUsingRPKM &
  done

