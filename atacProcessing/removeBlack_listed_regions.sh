cd ../../data/atac/peaks/
for day in 00 02 05 07 15 80
  do 
   intersectBed -a D${day}.ATAC.truepeak.narrowPeak -b $HOME/annotations/hg19/wgEncodeDacMapabilityConsensusExcludable.bed -v > D${day}.ATAC.truepeak.filtered.narrowPeak
  done

