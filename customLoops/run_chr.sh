pushd ../../analysis/customLoops/

#for sample in $(cat ../../data/hic/meta/names.txt); do

Rscript ../test.main.r ../../data/hic/matrix_raw/D00_HiC_Rep1/3_10000.txt chr3.d00.rep1.txt hic/matrix/D00_HiC_Rep1/3_10000.txt 

