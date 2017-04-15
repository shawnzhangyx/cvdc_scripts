dir="../../analysis/fithic/results"

for name in $(cat ../../data/hic/meta/names.txt)
  do 
  if [ ! -d $dir/$name/q0.01 ]; then mkdir $dir/$name/q0.01; fi
  done

for chr in {1..22..1} X
  do
  for name in $(cat ../../data/hic/meta/names.txt)
    do 
     ( num_line=$(zcat $dir/$name/${chr}.norm.spline_pass2.significances.txt.gz|awk 'END {print NR}') 
     zcat $dir/$name/${chr}.norm.spline_pass2.significances.txt.gz| 
     awk -v num=$num_line 'BEGIN{ }{ if( $6*num < 0.01) print $0 }' > $dir/$name/q0.01/${chr}.significant.txt ) &
    done
  wait
  echo $chr done
  done
