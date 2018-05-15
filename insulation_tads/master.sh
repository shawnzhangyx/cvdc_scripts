mkdir insulation_tads/
ln ../../data/hic/insulation/*.bed insulation_tads/

for file in $(ls insulation_tads/D??_HiC_Rep?.ins.boundaries.bed); do
  awk -v OFS="\t" -v name=${file/insulation_tads\/} '{ print $0,name}' $file
  done |sort --parallel=4 -k1,1 -k2,2n -k3,3n - >> combined_tads.raw.sorted.txt

