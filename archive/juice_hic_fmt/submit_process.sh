for i in 5 #1 2 3 4 6 7 8 9 10 11 12
  do
  sample=$(sed -n "${i}p" ../meta/sample_name.txt)
  qsub process_to_juicebox_fmt.qs -v name=$sample
  done
