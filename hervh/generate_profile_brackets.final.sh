files=$(ls hervh_rnaseq_brackets/*.bed)

for bw in \
    ../../data/tfChIPseq/bigWig/RAD21_ab992.D00.FE.bw \
    ../../data/tfChIPseq/bigWig/SMC3.ab9263.D00.FE.bw \
    ../../data/tfChIPseq/bigWig/RAD21_ab992.D00.bw \
    ../../data/tfChIPseq/bigWig/RAD21_sc98784.D00.bw \
    ../../data/tfChIPseq/bigWig/SMC3.ab9263.D00.bw \
    ; do
    computeMatrix scale-regions -S \
    $bw \
    -R $files \
    --regionBodyLength 10000 \
    --beforeRegionStartLength 20000 \
    --afterRegionStartLength 20000 \
    --binSize 100 \
    --averageTypeBins median \
    --skipZeros -o chipseq_profiles/$(basename $bw).mat.gz

  plotProfile -m chipseq_profiles/$(basename $bw).mat.gz \
    -out chipseq_profiles/$(basename $bw).profile.pdf
  done
