for sample in $(cat ../../data/hic/meta/names.txt); do
  echo $sample
  #sample=D00_HiC_Rep1
  cat ../../data/hic/oe_median/$sample/*.bedGraph |\
  awk -v OFS="\t" '{ if ($5< 181) {print "chr"$1,$2,$3,"NA" } else {print "chr"$1,$2,$3,$4}}' \
   > ../../data/hic/oe_median/${sample}.obs_exp.200.bedGraph
  done

