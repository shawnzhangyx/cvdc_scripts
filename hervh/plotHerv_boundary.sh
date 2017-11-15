#Rscript ../utility/calc_oe_median.r ../../analysis/tads/tad_boundary/test D00_HiC_Rep1

for day in D00 D02 D05 D07 D15 D80; do
#  for rep in Rep1 Rep2; do 
  for rep in Rep1;do
  Rscript ../utility/calc_oe_median.r ../../analysis/hervh/hervh.sorted_rnaseq.bed ${day}_HiC_${rep} ../../analysis/hervh/oe_median/
  done
  done


