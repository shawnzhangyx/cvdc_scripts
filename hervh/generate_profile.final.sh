## other ENCODE data. 
factor=CHD7
factor=POLR2A
echo $factor
computeMatrix reference-point -S \
    /mnt/silencer2/home/shz254/projects/H1/ENCODE/bigWig/${factor}-human.rep1,2.bigWig \
    -R $files \
    --beforeRegionStartLength 10000 \
    --afterRegionStartLength 10000 \
    --referencePoint center \
    --averageTypeBins median \
    --skipZeros -o chipseq_profiles/${factor}.mat.gz



for file in \
    /mnt/silencer2/home/shz254/projects/H1/ENCODE/bigWig/POLR2A-human.rep1,2.bigWig \
    /mnt/silencer2/home/shz254/projects/H1/ENCODE/bigWig/H3K4me3-human.rep1,2.bigWig \
    /mnt/silencer2/home/shz254/projects/H1/ENCODE/bigWig/TAF7-human.rep1,2.bigWig \
    /mnt/silencer2/home/shz254/projects/H1/ENCODE/bigWig/CHD7-human.rep1,2.bigWig \
    ~/../yanxiazh/projects/cardiac_dev/data/trackhub/hg19/rnaseq_D00.rpkm.bw \
    ../../data/rad21/D0_Rad21.bw \
    ../../data/rad21/D0_CTCF.bw 
  do
  echo $file
  computeMatrix scale-regions -S \
    $file \
    -R hervh.dynamicBoundaries.for_deeptools.bed \
    --regionBodyLength 10000 \
    --beforeRegionStartLength 20000 \
    --afterRegionStartLength 20000 \
    --averageTypeBins median \
    --skipZeros -o chipseq_profiles/DynB.$(basename $file).mat.gz

  plotProfile -m chipseq_profiles/DynB.$(basename $file).mat.gz \
    --numPlotsPerRow 1 \
    -out chipseq_profiles/DynB.$(basename $file).profile.pdf
  done

#convert chipseq_profiles/DynB.*.pdf -append DynB.test.pdf
