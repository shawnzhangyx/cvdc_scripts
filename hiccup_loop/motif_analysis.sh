pushd ../../analysis/hiccup_loops/clusters/sep_by_cluster/
# derive FASTA file
for file in $(ls cluster.?.bed); do
  fastaFromBed -fi ~/annotations/hg19/hg19.fa -bed $file > ${file/bed/fasta}
  done
# FIMO
for file in $(ls cluster.?.fasta);do
  fimo --text  ~/software/meme/motifs/vertebrate.motif $file > \
  ${file/fasta/motif_match.txt} &
  done
# HOMER
for file in $(ls cluster.?.bed); do
  findMotifsGenome.pl $file hg19 ${file/.bed/.homer} -size -5000,5000 &
  done

for file in $(ls cluster.?.motif_match.txt); do
  echo $file
  awk -v OFS="\t" '{ if (NR>1) count[$1]++ } 
    END { for (idx in count) print idx,count[idx]}' $file > ${file/motif_match.txt/motif_count.txt} 
  done

tail -n +2 cluster.1.motif_match.txt |sort -k1,1 -k2,2 -u > test
for file in $(ls cluster.?.motif_match.txt); do
  echo $file
  awk -v OFS="\t" '!count[$1][$2]++' $file |awk -v OFS="\t" '{ if (NR>1) count[$1]++ }
      END { for (idx in count) print idx,count[idx]}' - > ${file/motif_match.txt/motif_peak_count.txt}
  done




