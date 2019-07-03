
for day in D00 D02 D05 D07 D15 D80; do
#  for rep in Rep1 Rep2; do
  for rep in Rep1 Rep2; do
  qsub -v day=$day,rep=$rep calc_oe_median.qs
#  Rscript ../utility/calc_oe_median.r ../../analysis/di_tads.10k/boundaries/boundary.all.txt ${day}_HiC_${rep} ../../analysis/di_tads.10k/oe_median/
  done
  done

