cd ../../data/hic/juicer/
if [ ! -d ../juicerBias ]; then mkdir ../juicerBias; fi 
#chr=14
for chr in {1..22..1} X
do 
for name in *.hic
  do 
  name=${name/.hic/}
  if [ ! -d ../juicerBias/$name ]; then mkdir ../juicerBias/$name; fi
  java -Xms8G -Xmx8G -jar $HOME/software/hic/juicebox/juicebox_tools.7.0.jar dump norm KR $name.hic chr$chr chr$chr BP 10000 ../juicerBias/$name/${chr}_10000.txt
  done
done
