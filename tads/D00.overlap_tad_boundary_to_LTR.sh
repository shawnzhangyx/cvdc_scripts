cd  ../../analysis/tads/stage_specific_tads/
  > D00.boundary.repeats_counts.txt
for repeats in $(ls ../../../data/annotation/repeats/*.txt); do
  name=$(basename $repeats)
  name=${name%.txt}
a1=$(intersectBed -a <(awk -v OFS="\t" '{print $1,$2,$2+50000}' D00.unique.tads.inc25k.bed) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u |wc -l) #18

a2=$(intersectBed -a <(awk -v OFS="\t" '{print $1,$3-50000,$3}' D00.unique.tads.inc25k.bed) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u |wc -l)

b1=$(intersectBed -a <(awk -v OFS="\t" '{print $1,$2-25000,$2+25000}' D80.unique.tads ) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u |wc -l)

b2=$(intersectBed -a <(awk -v OFS="\t" '{print $1,$3-25000,$3+25000}' D80.unique.tads ) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u |wc -l )


c1=$(intersectBed -a <(awk -v OFS="\t" '{print $1,$2,$2+50000}' D00.unique.tads.inc25k.random_10x.bed ) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u |wc -l)
c2=$(intersectBed -a <(awk -v OFS="\t" '{print $1,$3-50000,$3}' D00.unique.tads.inc25k.random_10x.bed ) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u |wc -l)

d1=$(intersectBed -a <(awk -v OFS="\t" '{ if (NR>1){print $1,$2-25000,$2+25000}}' ../combined_tads.uniq.gt1.txt ) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u |wc -l)

d2=$(intersectBed -a <(awk -v OFS="\t" '{ if (NR>1){print $1,$3-25000,$3+25000}}' ../combined_tads.uniq.gt1.txt ) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u |wc -l)

  echo -e "$name\t$((a1+a2))\t$((b1+b2))\t$((c1+c2))\t$((d1+d2))" |tee -a D00.boundary.repeats_counts.txt
  done


