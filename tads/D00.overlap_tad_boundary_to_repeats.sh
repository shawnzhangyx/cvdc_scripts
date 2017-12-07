cd  ../../analysis/tads/stage_specific_tads/
  > D00.boundary.repeats_counts.txt
for repeats in $(ls ../../../data/annotation/repeats/*.txt); do
  name=$(basename $repeats)
  name=${name%.txt}
  #mkfifo o1 o2
  intersectBed -a <(awk -v OFS="\t" '{print $1,$2,$2+50000}' D00.unique.tads.inc25k.bed) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -c > o1 
  intersectBed -a <(awk -v OFS="\t" '{print $1,$3-50000,$3}' D00.unique.tads.inc25k.bed) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -c > o2 
  a1=$(paste o1 o2 | awk 'BEGIN{n=0} {if ($4>0 || $8>0) { n++} } END {print n}')

  intersectBed -a <(awk -v OFS="\t" '{print $1,$2-25000,$2+25000}' D80.unique.tads) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -c > o1
  intersectBed -a <(awk -v OFS="\t" '{print $1,$3-25000,$3+25000}' D80.unique.tads) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -c > o2
  a2=$(paste o1 o2 | awk 'BEGIN{n=0} {if ($4>0 || $8>0) { n++} } END {print n}')

  intersectBed -a <(awk -v OFS="\t" '{print $1,$2,$2+50000}' D00.unique.tads.inc25k.random_10x.bed) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -c > o1
  intersectBed -a <(awk -v OFS="\t" '{print $1,$3-50000,$3}' D00.unique.tads.inc25k.random_10x.bed) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -c > o2
  a3=$(paste o1 o2 | awk 'BEGIN{n=0} {if ($4>0 || $8>0) { n++} } END {print n}')

  intersectBed -a <(awk -v OFS="\t" '{ if (NR>1){print $1,$2-50000,$2+50000}}' ../combined_tads.uniq.gt1.txt ) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -c > o1
  intersectBed -a <(awk -v OFS="\t" '{ if (NR>1){print $1,$3-50000,$3+50000}}' ../combined_tads.uniq.gt1.txt ) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -c > o2
  a4=$(paste o1 o2 | awk 'BEGIN{n=0} {if ($4>0 || $8>0) { n++} } END {print n}')
  echo -e "$name\t${a1}\t${a2}\t${a3}\t${a4}" |tee -a D00.boundary.repeats_counts.txt
  done


## refine repeat enrichment analysis
DISTANCE=25000
for name in HERVH-int; do
  intersectBed -a <(awk -v OFS="\t" -v DISTANCE=$DISTANCE '{print $1,$2-DISTANCE,$2+DISTANCE}' D00.unique.tads) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -c > o1
  intersectBed -a <(awk -v OFS="\t" -v DISTANCE=$DISTANCE '{print $1,$3-DISTANCE,$3+DISTANCE}' D00.unique.tads) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -c > o2
  paste o1 o2 | awk '{if ($4>0 || $8>0) { print NR}}' > test

