cd  ../../analysis/di_tads.10k.2M/dynamic_bd/
  > D00.boundary.repeats_counts.txt
for repeats in $(ls ../../../data/annotation/repeats/*.txt); do
  name=$(basename $repeats)
  name=${name%.txt}
  #mkfifo o1 o2
  a1=$(intersectBed -a <(awk -v OFS="\t" '{print $1,$2-50000,$2+50000}' d00.txt) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u |wc -l)
  a2=$(intersectBed -a <(awk -v OFS="\t" '{print $1,$2-50000,$2+50000}' d80.txt) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u |wc -l)
  a3=$(intersectBed -a <(awk -v OFS="\t" '{print $1,$2-50000,$2+50000}' stable.txt) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u |wc -l)
  echo -e "$name\t${a1}\t${a2}\t${a3}" |tee -a D00.boundary.repeats_counts.txt
  done


## refine repeat enrichment analysis
DISTANCE=25000
for name in HERVH-int; do
  intersectBed -a <(awk -v OFS="\t" -v DISTANCE=$DISTANCE '{print $1,$2-DISTANCE,$2+DISTANCE}' D00.unique.tads) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -c > o1
  intersectBed -a <(awk -v OFS="\t" -v DISTANCE=$DISTANCE '{print $1,$3-DISTANCE,$3+DISTANCE}' D00.unique.tads) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -c > o2
  paste o1 o2 | awk '{if ($4>0 || $8>0) { print NR}}' > test

