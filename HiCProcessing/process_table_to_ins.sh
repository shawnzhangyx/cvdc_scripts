#sample=D00_HiC_Rep1
#chr=22

for sample in $(cat ../../data/hic/meta/names.txt); do
  echo $sample
  (
  cd ../../data/hic/insulation/$sample/
  for chr in {22..1..1} X; do
  if [ ! -e chr${chr}.tab.is500001.ids200001.insulation.boundaries.bed ]; 
  then   echo chr$chr ; 
  perl ../../../../scripts/HiCProcessing/matrix2insulation.pl -i ../../table2x2/$sample/chr${chr}.tab.gz -is 500000 -ids 200000 -im mean -bmoe 3 -nt 0.1 -v &
  fi 
  done
  )
done

for sample in $(cat ../../data/hic/meta/names.txt); do
  echo $sample
#  cat ../../data/hic/insulation/$sample/*.bedGraph |grep -v NA > ../../data/hic/insulation/${sample}.ins.is500001.ids200001.bedGraph
  cat ../../data/hic/insulation/$sample/*.bed |grep track -v > ../../data/hic/insulation/${sample}.ins.boundaries.bed
  done


