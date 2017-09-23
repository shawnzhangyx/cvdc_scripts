# HOMER
pushd  ../../analysis/customLoops/clusters/atac_peaks/
for file in $(ls *.txt); do
  findMotifsGenome.pl $file hg19 ${file/.txt/.homer} &
  done

