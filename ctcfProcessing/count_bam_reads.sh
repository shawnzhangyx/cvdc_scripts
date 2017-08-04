pushd ../../data/ctcf/bam
for file in *.bam;do 
  echo $file
  echo "$file $(samtools view -c $file)" >> total_counts.txt &
  done

popd
