pushd ../../analysis/customLoops
computeMatrix scale-regions -S  \
              ../../data/trackhub/hg19/H3K27ac_D00.rpkm.bw \
              ../../data/trackhub/hg19/H3K27ac_D02.rpkm.bw \
              ../../data/trackhub/hg19/H3K27ac_D15.rpkm.bw \
                              -R clusters/loops.2.order.bed  \
                              --beforeRegionStartLength 10000 \
                              --regionBodyLength 30000 \
                              --afterRegionStartLength 10000 \
                              --skipZeros -o matrix.mat.gz

plotHeatmap -m matrix.mat.gz \
      -out ExampleHeatmap1.png  \
      --whatToShow 'heatmap and colorbar' \
      --sortRegions no \
      --colorList 'white,red' 
