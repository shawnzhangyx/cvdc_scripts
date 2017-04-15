python3env
mkdir  ../../analysis/bbinomial/
dir="../../analysis/bbinomial/results"
if [ ! -d $dir ]; then mkdir $dir; fi
chr=14
bin=10000
for chr in {1..22..1} X 
do 
for name in $(cat ../../data/hic/meta/names.txt)
  do
  (
  infile=../../data/hic/matrix/$name/${chr}_${bin}.txt
  if [ ! -d $dir/$name ]; then mkdir $dir/$name; fi
  out=$dir/$name/
  python $HOME/software/github/hic-peak-caller/fit-hic-beta-binomial.py -i $infile -n ${chr}_${bin} --output-dir $out --max-distance 2000000
  ) &
  done

wait
echo $chr done
done
