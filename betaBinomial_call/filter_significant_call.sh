dir="../../analysis/bbinomial/results"

for name in $(cat ../../data/hic/meta/names.txt)
  do
  if [ ! -d $dir/$name/q0.05 ]; then mkdir $dir/$name/q0.05; fi
  done

for chr in 14 #{1..22..1} X
  do
  for name in $(cat ../../data/hic/meta/names.txt)
    do
     ( cat $dir/$name/${chr}_10000.test.txt | awk '{ if( $4 < 0.05) print $0 }' > $dir/$name/q0.05/${chr}.significant.txt ) &
    done
  wait
  echo $chr done
  done

