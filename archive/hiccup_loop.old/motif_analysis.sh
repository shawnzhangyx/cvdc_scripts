pushd ../../analysis/hiccup_loops/clusters/atac/
# derive FASTA file
for file in $(ls *.bed); do
  fastaFromBed -fi ~/annotations/hg19/hg19.fa -bed $file > ${file/bed/fasta}
  done
# FIMO
for file in $(ls *.fasta);do
  fimo --text  ~/software/meme/motifs/vertebrate.motif $file > \
  ${file/fasta/motif_match.txt} &
  done
  wait
# HOMER
for file in $(ls *.bed); do
  findMotifsGenome.pl $file hg19 ${file/.bed/.homer} &
  done
  wait
for file in $(ls *.motif_match.txt); do
  echo $file
  awk -v OFS="\t" '{ if (NR>1) count[$1]++ } 
    END { for (idx in count) print idx,count[idx]}' $file > ${file/motif_match.txt/motif_count.txt} 
  done
  wait

tail -n +2 ,,,.motif_match.txt |sort -k1,1 -k2,2 -u > test

for file in $(ls *.motif_match.txt); do
  echo $file
  awk -v OFS="\t" '!count[$1][$2]++' $file |awk -v OFS="\t" '{ if (NR>1) count[$1]++ }
      END { for (idx in count) print idx,count[idx]}' - > ${file/motif_match.txt/motif_peak_count.txt}
  done

## only use distal peaks.
mkdir -p distal

for file in $(ls *.bed); do
  intersectBed -a $file -b ../../../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -v > distal/$file
  done
cd distal

for file in $(ls *.bed); do
  fastaFromBed -fi ~/annotations/hg19/hg19.fa -bed $file > ${file/bed/fasta}
  done
# FIMO
for file in $(ls *.fasta);do
  fimo --text  ~/software/meme/motifs/vertebrate.motif $file > \
  ${file/fasta/motif_match.txt} &
  done
  wait
# HOMER
#for file in $(ls *.bed); do
#  findMotifsGenome.pl $file hg19 ${file/.bed/.homer} &
#  done
#  wait
for file in $(ls *.motif_match.txt); do
  echo $file
  awk -v OFS="\t" '{ if (NR>1) count[$1]++ }
    END { for (idx in count) print idx,count[idx]}' $file > ${file/motif_match.txt/motif_count.txt}
  done
  wait

for file in $(ls *.motif_match.txt); do
  echo $file
  awk -v OFS="\t" '!count[$1][$2]++' $file |awk -v OFS="\t" '{ if (NR>1) count[$1]++ }
      END { for (idx in count) print idx,count[idx]}' - > ${file/motif_match.txt/motif_peak_count.txt}
  done

