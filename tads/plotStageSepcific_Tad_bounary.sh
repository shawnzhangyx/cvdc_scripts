#Rscript ../utility/calc_oe_median.r ../../analysis/tads/tad_boundary/test D00_HiC_Rep1

for day in D00 D02 D05 D07 D15 D80; do
  for rep in Rep1 Rep2; do 
  Rscript ../utility/calc_oe_median.r ../../analysis/tads/tad_boundary/D00.specific.boundary.bed ${day}_HiC_${rep}
  done
  done


