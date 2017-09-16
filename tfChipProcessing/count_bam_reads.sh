pushd ../../data/tfChIPseq/bam
> total_counts.txt
for file in *.bam;do 
  echo $file
  echo "$file $(samtools view -c $file)" >> total_counts.txt &
  done
wait
sort -k1,1 total_counts.txt > total_counts.name_sorted.txt
sort -k2,2n total_counts.txt > total_counts.read_sorted.txt
popd
