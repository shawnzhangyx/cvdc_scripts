pushd ../../analysis/customLoops

for sample in $(cat ../../data/hic/meta/names.txt); do
  awk -v OFS="\t" '{ if (NR==1) print "chr",$1,$2,$3,$4,$6,$13,$15,$20,$21}' tests_sample_chr/chr1.${sample}.txt.removed.merged > loops_by_sample/${sample}.loops
  for chr in {1..22} X; do
   tail -n +2 tests_sample_chr/chr${chr}.${sample}.txt.removed.merged | \
    awk -v OFS="\t" -v chr=$chr '{print "chr"chr,$1,$2,$3,$4,$6,$13,$15,$20,$21 }' >> loops_by_sample/${sample}.loops
    done
  done

