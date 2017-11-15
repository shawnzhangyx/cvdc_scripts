intersectBed \
  -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000} else {print $1,$2-400000,$3+400000 }}' hervh.sorted_rnaseq.bed) \
  -b ../tads/directionality_data/D00_1_norm.DI.bedgraph \
  -wo > D00.norm.DI

intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000} else {print $1,$2-400000,$3+400000 }}' hervh.sorted_rnaseq.bed) \
      -b ../tads/insulation_data/D00_1.bedgraph \
      -wo > D00.insulation

