cd ../../analysis/hervh/
mkdir -p inter_chrom_int/D00_HiC_Rep1/
sample=../../data/hic/juicer/D00_HiC_Rep1.hic
for chr1 in {1..22} ; do 
#  for chr2 in $(seq $((${chr1} + 1)) 22) X;do
chr2=$chr1
  ../../scripts/utility/straw NONE $sample chr$chr1 chr$chr2 BP 10000 > inter_chrom_int/D00_HiC_Rep1/chr.${chr1}.${chr2}.10k.mat

#done
done


