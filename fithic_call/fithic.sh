dir="../../analysis/fithic/results"
if [ ! -d $dir ]; then mkdir $dir; fi
#chr=14
#bin=10000
#for name in $(cat ../../data/hic/meta/names.txt)
#  do
#  (
#  path=../../analysis/fithic/preprocessed_data/$name
#  interaction=$path/${chr}_${bin}.contact.txt.gz
#  frag=$path/${chr}_${bin}.frag.txt.gz
#  bias=$path/${chr}_${bin}.bias.txt.gz
#  if [ ! -d $dir/$name ]; then mkdir $dir/$name; fi
#  if [ ! -d $dir/$name/$chr ]; then mkdir $dir/$name/$chr; fi
#  out=$dir/$name/$chr
#  python $HOME/software/hic/fithic/bin/fit-hi-c.py -f $frag -i $interaction -t $bias -o $out  ) &
#  done
#
#wait
#echo done


### 

dir="../../analysis/fithic/results"
if [ ! -d $dir ]; then mkdir $dir; fi
bin=10000
chr=1
for chr in {1..22..1} X 
do 
  (
for name in $(cat ../../data/hic/meta/names.txt)
  do
  path=../../analysis/fithic/preprocessed_data/$name
  interaction=$path/${chr}_${bin}.contact.norm.txt.gz
  frag=$path/${chr}_${bin}.frag.norm.txt.gz
  if [ ! -d $dir/$name ]; then mkdir $dir/$name; fi
  out=$dir/$name
  python $HOME/software/hic/fithic/bin/fit-hi-c.py -f $frag -i $interaction -o $out -l ${chr}.norm -b 500 -L 15000 -U 5000000
  done
  ) &
done 

echo submitted 

