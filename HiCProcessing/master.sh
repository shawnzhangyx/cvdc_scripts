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


## run on TSCC
qsub process_interaction_to_insulation.qs
## calculate insulation again
for sample in $(cat ../../data/hic/meta/names.txt); do
  (
  for chr in {1..22} X; do
    Rscript insulation_modified.r $chr $sample  
  done
  ) &
done

pushd ../../data/hic/insulation/
for sample in $(cat ../meta/names.txt); do
#  cat $sample/*_ins.500.bedGraph | sed 's/^/chr/g'  > ${sample}_ins.500.bedGraph
  cat $sample/*.ins2.500.bedGraph | sed 's/^/chr/g'  > ${sample}.ins2.500.bedGraph

  done

