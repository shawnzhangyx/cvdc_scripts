cd ../../data/hic/juicer/
for name in $(ls *.hic)
  do
  name=${name/.hic/}
  mkdir ../matrix/$name
  for chr in $(seq 1 22) X
    do
    (
    echo $chr
     java -Xms512m -Xmx2048m -jar $HOME/software/hic/juicebox/juicebox_tools.7.0.jar dump observed KR $name.hic $chr $chr BP 100000 ../matrix/$name/${chr}_100000.txt
    ) &
    done
    wait 
    echo $name done
done
