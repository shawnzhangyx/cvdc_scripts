for sample in $(cat ../../data/hic/meta/names.txt); do 
  echo $sample
  intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$1":"$2"-"$3 } else {print $1,$2-400000,$3+400000,$1":"$2"-"$3 }}' hervh.sorted_rnaseq.bed) \
    -b ../../data/hic/DI/${sample}.10000.50.DI.bedGraph \
  -wo > DI/${sample}.DI.overlap.txt
  done

# overlap TSSs with DIs. 
for sample in $(cat ../../data/hic/meta/names.txt); do
  echo $sample
  intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$4 } else {print $1,$2-400000,$3+400000,$4}}' D00.rna_seq.ranked_by_rpkm.bed) \
    -b ../../data/hic/DI/${sample}.10000.50.DI.bedGraph \
  -wo > tss_DI_profile/${sample}.DI.overlap.txt
  done

#    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$1":"$2"-"$3":"$4":"$5 } else {print $1,$2-400000,$3+400000,$1":"$2"-"$3":"$4":"$5 }}' ../../data/rnaseq/D00.rna_seq.ranked_by_rpkm.bed) \
