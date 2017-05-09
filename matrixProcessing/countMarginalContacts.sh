for name in $(cat ../../data/hic/meta/names.txt)
  do 
  (
  echo $name
  for chr in {1..22..1} X
    do
    echo $chr
    python ../utility/calMarginal.py ../../data/hic/matrix/$name/${chr}_10000.txt  
    done
  ) &
  done

wait 
echo done

echo > ../../data/hic/matrix/marginalCounts.txt
for name in $(cat ../../data/hic/meta/names.txt)
  do
  echo $name
  for chr in {1..22..1} X
    do
    echo $chr
    echo $name $chr $(awk '{print $2;exit}' ../../data/hic/matrix/$name/${chr}_10000.txt.mar) >> ../../data/hic/matrix/marginalCounts.txt

    done
  done
