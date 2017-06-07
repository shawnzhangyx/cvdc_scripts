analysis=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis
data=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data
for day in D00 D02 D05 D07 D15 D80; do 
  for rep in 1 2; do 
 #   sort -k1,1 -k2,2n $analysis/tads/directionality_data/${day}_${rep}_norm.DI.bedgraph > temp && bedGraphToBigWig temp ~/annotations/hg19/hg19.chrom.sizes $data/trackhub/hg19/DI.${day}.rep${rep}.bw
 #   sortBed -i $analysis/tads/insulation_data/${day}_${rep}.bedgraph > temp && bedGraphToBigWig temp  ~/annotations/hg19/hg19.chrom.sizes $data/trackhub/hg19/Insulation.${day}.rep${rep}.bw
    sortBed -i $analysis/ab_compartments/pc1_data/${day}_${rep}_*_pcaOut.PC1.bedGraph > temp && bedGraphToBigWig temp ~/annotations/hg19/hg19.chrom.sizes $data/trackhub/hg19/PC1.${day}.rep${rep}.bw
    done
  done
