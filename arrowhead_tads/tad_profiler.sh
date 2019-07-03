pushd ../../analysis/tads/

computeMatrix scale-regions \
  -S ../../data/tfChIPseq/bigWig/CTCF_D00_merged.rpkm.bw \
     ../../data/tfChIPseq/bigWig/CTCF_D02_merged.rpkm.bw \
     ../../data/tfChIPseq/bigWig/CTCF_D07_merged.rpkm.bw \
     ../../data/tfChIPseq/bigWig/CTCF_D15_merged.rpkm.bw \
  -R D00.unique.tads \
  --beforeRegionStartLength 10000 \
  --regionBodyLength 50000 \
  --afterRegionStartLength 10000 \
  --skipZeros -o D00.CTCF.matrix.mat.gz

plotProfile -m D00.CTCF.matrix.mat.gz \
              -out CTCF.Profile.png \
              --numPlotsPerRow 4 \
              --plotTitle "CTCF data profile"


computeMatrix scale-regions \
  -S ../../data/trackhub/hg19/H3K27ac_D00.rpkm.bw \
     ../../data/trackhub/hg19/H3K27ac_D02.rpkm.bw \
     ../../data/trackhub/hg19/H3K27ac_D05.rpkm.bw \
     ../../data/trackhub/hg19/H3K27ac_D07.rpkm.bw \
     ../../data/trackhub/hg19/H3K27ac_D15.rpkm.bw \
     ../../data/trackhub/hg19/H3K27ac_D80.rpkm.bw \
  -R D00.unique.tads \
  --beforeRegionStartLength 10000 \
  --regionBodyLength 50000 \
  --afterRegionStartLength 10000 \
  --skipZeros -o D00.H3K27ac.matrix.mat.gz

plotProfile -m D00.H3K27ac.matrix.mat.gz \
              -out ExampleProfile1.png \
              --numPlotsPerRow 4 \
              --plotTitle "H3K27ac data profile"


#### RNA-seq 

