cd ../../analysis/di_tads.10k
for sample in $(cat ../../data/hic/meta/names.txt); do
  echo $sample
  intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-200000 <0){print $1,0,$2+200000,$1":"$2 } else {print $1,$2-200000,$2+200000,$1":"$2 }}' boundaries/boundary.all.txt) \
    -b ../../data/hic/oe_median/${sample}.obs_exp.200.bedGraph \
  -wo > oe_median2/${sample}.oe_median.overlap.txt
  done

