#combine_all_cis_reads_by_chr.py
pushd ../../data/hic/matrix/
chr=1
for chr in 14; do
  files=$(ls D??_HiC_Rep?/${chr}_10000.txt)
  python  ../../../scripts/HiCProcessing/combine_all_cis_reads_by_chr.py --contact-file $files --out-file chr${chr}_combined.txt --chr $chr
  done
popd 

convert_valid_pairs_to_matrix.sh
straw_extractInteraction.sh
