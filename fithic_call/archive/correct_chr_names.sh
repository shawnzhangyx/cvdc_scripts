dir="../../analysis/fithic/results"
for chr in {1..22..1} X
  do 
  for name in $(cat ../../data/hic/meta/names.txt)
    do
    (
    prefix=$dir/$name/${chr}.norm.spline_pass2.significances.txt
    zcat $prefix.gz | awk -v OFS="\\t" -v chr=$chr '{ if ($1 != "chr1"){ print chr,$2,chr,$4,$5,$6,$7 } else {print $0} }' > $prefix 
    gzip -f $prefix
    ) & 
    done
  wait 
  echo $chr done
  done
