#for sample in D00_HiC_Rep1 D00_HiC_Rep2 D80_HiC_Rep1 D80_HiC_Rep2; do
for sample in $(cat ../../data/hic/meta/names.txt);do
  Rscript calc_ab_trans_contacts.r $sample & 
#  Rscript calc_ab_trans_bins.r $sample &
  done
