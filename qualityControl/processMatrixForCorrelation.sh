cd ../../data/hic/matrix/
for name in $(cat ../meta/names.txt)
  do
  echo $name
  for chr in {1..22..1} X 
    do 
    echo $chr
    cat $name/${chr}_100000.txt | awk -v chr=$chr -v OFS='\t' '{ if ( $2-$1 < 5000000 && $1 != $2 ) {print chr,$0} }' >> ../../../analysis/qualityControl/contactMatrix_lt5m/${name}_100000.txt
    done
  done


