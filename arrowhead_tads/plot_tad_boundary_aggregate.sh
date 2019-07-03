for day in D00 D80 gain; do
  awk -v OFS="\t" '{print $1,$2,$2+10000,$1,$3-10000,$3+10000}' ${day}.within.tads > ${day}.within.tads.juicer
  done

for tads in D00 D80 gain; do
  mkdir -p ${tads}.within
  for day in D00 D02 D05 D07 D15 D80; do 
  java -jar /mnt/silencer2/home/yanxiazh/software/hic/juicebox/juicebox_tools.7.0.jar apa -k KR -r 10000 -w 20 \
  ../../../data/hic/juicer/${day}_HiC_Rep1.hic ${tads}.within.tads.juicer ${tads}.within/${day} &
  done
  done
