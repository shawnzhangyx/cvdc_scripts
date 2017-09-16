pushd ../../data/tfChIPseq/
for name in TBX5 GATA4 NKX2.5 MEF2C ; do
  findMotifsGenome.pl peaks/$name/${name}_peaks.narrowPeak hg19 motifs/$name.homer &
  done

