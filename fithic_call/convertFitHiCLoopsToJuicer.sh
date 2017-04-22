bin=10000
for name in $(cat ../../data/hic/meta/names.txt)
  do
  fileout=../../analysis/fithic/results/$name/q0.01/combined.Juicer.txt
  echo -e "chr1\tx1\tx2\tchr2\ty1\ty2\tcolor" > $fileout
  for chr in {1..22..1} X
    do 
    filein=../../analysis/fithic/results/$name/q0.01/${chr}.significant.txt
    awk -v OFS="\t" -v bin=$bin '{if (NR !=1)print $1,$2,$2+bin,$3,$4,$4+bin,"0,0,0"}' $filein >> $fileout

    done
  done

