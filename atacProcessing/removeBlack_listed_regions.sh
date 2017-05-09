cd ../../data/atac/
for day in 00 02 05 07 15 80
  do 
   intersectBed -a bams/D${day}/IDR/pooled.truerep.narrowPeak -b $HOME/annotations/hg19/wgEncodeDacMapabilityConsensusExcludable.bed -v > peaks/D${day}.ATAC.truepeak.filtered.narrowPeak
  done

