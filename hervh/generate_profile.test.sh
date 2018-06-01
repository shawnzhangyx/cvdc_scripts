for start in {1..351..50};do 
  echo $start
  sed -n "$start,$((start+49))p" hervh.sorted_rnaseq.bed > chipseq_profiles/hervh.rank.${start}_$((start+49)).bed 
done

files=$(ls chipseq_profiles/*.bed)

#computeMatrix scale-regions -S \
computeMatrix reference-point -S \
  ../../data/trackhub/hg19/H3K27ac_D00.rpkm.bw \      
    -R $files \
    --beforeRegionStartLength 10000 \
    --afterRegionStartLength 10000 \
    --referencePoint center \
    --averageTypeBins median \
    --skipZeros -o chipseq_profiles/H3K27ac_D00.mat.gz

plotHeatmap -m chipseq_profiles/H3K27ac_D00.mat.gz \
    -out chipseq_profiles/H3K27ac_D00.heatmap.png

plotProfile -m chipseq_profiles/H3K27ac_D00.mat.gz \
    -out chipseq_profiles/H3K27ac_D00.profile.png \
    --numPlotsPerRow 2 \
    --perGroup 
#    --averageType median \

## CTCF data. 

computeMatrix reference-point -S \
  ../../data/tfChIPseq/bigWig/CTCF_D00_merged.rpkm.bw \
    -R $files \
    --beforeRegionStartLength 10000 \
    --afterRegionStartLength 10000 \
    --referencePoint center \
    --averageTypeBins median \
    --skipZeros -o chipseq_profiles/CTCF_D00.mat.gz

plotHeatmap -m chipseq_profiles/CTCF_D00.mat.gz \
    --colorList 'black, yellow' \
    -out chipseq_profiles/CTCF_D00.heatmap.png


plotProfile -m chipseq_profiles/CTCF_D00.mat.gz \
    -out chipseq_profiles/CTCF_D00.profile.png \
    --numPlotsPerRow 2 \
    --perGroup

## other ENCODE data. 
factor=CHD7
factor=POLR2A
for factor in $(cat /mnt/silencer2/home/shz254/projects/H1/ENCODE/bigWig/factors.txt); do
echo $factor
computeMatrix reference-point -S \
    /mnt/silencer2/home/shz254/projects/H1/ENCODE/bigWig/${factor}-human.rep1,2.bigWig \
    -R $files \
    --beforeRegionStartLength 10000 \
    --afterRegionStartLength 10000 \
    --referencePoint center \
    --averageTypeBins median \
    --skipZeros -o chipseq_profiles/${factor}.mat.gz

plotHeatmap -m chipseq_profiles/${factor}.mat.gz \
    --colorList 'black, yellow' \
    -out chipseq_profiles/${factor}.heatmap.png
done


computeMatrix scale-regions -S \
    ../../data/rad21/D0_Rad21.bw \
    ../../data/rad21/D0_Med12.bw \
    ../../data/rad21/D0_CTCF.bw \
    -R hervh.dynamicBoundaries.for_deeptools.bed \
    --regionBodyLength 10000 \
    --beforeRegionStartLength 20000 \
    --afterRegionStartLength 20000 \
    --averageTypeBins median \
    --skipZeros -o jian_data/RAD21.CTCF.mat.gz

computeMatrix scale-regions -S \
    ../../../H1/ENCODE/bigWig/POLR2A-human.rep1,2.bigWig \
    -R hervh.dynamicBoundaries.for_deeptools.bed \
    --regionBodyLength 10000 \
    --beforeRegionStartLength 20000 \
    --afterRegionStartLength 20000 \
    --averageTypeBins median \
    --skipZeros -o jian_data/POLR2A.mat.gz


plotHeatmap -m jian_data/RAD21.CTCF.mat.gz \
    --sortRegions no \
    --colorList 'black, yellow' \
    -out jian_data/RAD21.CTCF.heatmap.png


plotHeatmap -m jian_data/POLR2A.mat.gz \
    --sortRegions no \
    --colorList 'black, yellow' \
    -out jian_data/POLR2A.heatmap.png

