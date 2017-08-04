pushd ../../data/ctcf/fastq/
for file in *.bz2;do 
  echo $file
  echo "$file $(bzcat $file|wc -l)" >> total_counts.txt &
  done
