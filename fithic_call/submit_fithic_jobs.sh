dir="/oasis/tscc/scratch/shz254/projects/cardiac_dev/analysis/fithic/results"
if [ ! -d $dir ]; then mkdir $dir; fi
bin=10000
for chr in {1..22..1} X
do
for name in $(cat /oasis/tscc/scratch/shz254/projects/cardiac_dev/data/hic/meta/names.txt)
  do
#  (
  path=/oasis/tscc/scratch/shz254/projects/cardiac_dev/analysis/fithic/preprocessed_data/$name
  interaction=$path/${chr}_${bin}.contact.norm.txt.gz
  frag=$path/${chr}_${bin}.frag.norm.txt.gz
  if [ ! -d $dir/$name ]; then mkdir $dir/$name; fi
  out=$dir/$name
  echo "qsub fithic.qs -v frag=$frag,interaction=$interaction,out=$out,chr=$chr"
  qsub fithic.qs -v frag=$frag,interaction=$interaction,out=$out,chr=$chr
#  ) &
  done

wait
echo done
done

