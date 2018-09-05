mkdir hervh_rnaseq_brackets
for start in {1..351..50};do
  end=$(printf "%03d" $((start+49)))
  start=$(printf "%03d" $start)
  echo $start $end
  sed -n "$start,${end}p" hervh.sorted_rnaseq.strand.bed > hervh_rnaseq_brackets/hervh.rank.${start}_${end}.bed
done

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


for bw in ../../../H1/ENCODE/bigWig/TAF7-human.rep1,2.bigWig \
    ../../data/rad21/D0_Rad21.bw \
    ../../data/rad21/D0_CTCF.bw \
    ../../data/tfChIPseq/bigWig/CTCF_D00_merged.rpkm.bw \
    ../../../H1/ENCODE/bigWig/POLR2A-human.rep1,2.bigWig \
    ~/../yanxiazh/projects/cardiac_dev/data/trackhub/hg19/rnaseq_D00.rpkm.bw \
    ; do 
    computeMatrix scale-regions -S \
    $bw \
    -R $files \
    --regionBodyLength 10000 \
    --beforeRegionStartLength 20000 \
    --afterRegionStartLength 20000 \
    --averageTypeBins median \
    --skipZeros -o chipseq_profiles/$(basename $bw).mat.gz

  plotProfile -m chipseq_profiles/$(basename $bw).mat.gz \
    -out chipseq_profiles/$(basename $bw).profile.pdf
  done 
#    --numPlotsPerRow 2 \
#    --perGroup

## plot for each stage RAD21

bws=$(ls ../../data/rad21/D?_Rad21.bw)
  computeMatrix scale-regions -S \
    $bws \
    -R hervh_rnaseq_brackets/hervh.rank.001_050.bed \
    --regionBodyLength 10000 \
    --beforeRegionStartLength 20000 \
    --afterRegionStartLength 20000 \
    --averageTypeBins median \
    --skipZeros -o chipseq_profiles/D0-D5.RAD21.hervh.rank001-050.mat.gz

  plotProfile -m chipseq_profiles/D0-D5.RAD21.hervh.rank001-050.mat.gz \
  --perGroup \
    -out chipseq_profiles/D0-D5.RAD21.hervh.rank001-050.profile.pdf

