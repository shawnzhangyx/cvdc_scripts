pushd ../../data/tfChIPseq/peaks/

#ATAC
> TF_overlap_ATAC.summary
for TF in TBX5 NKX2.5 GATA4 MEF2C; do
  echo -e "$TF\t$(wc -l $TF/${TF}_peaks.narrowPeak)"  >> TF_overlap_ATAC.summary
  for day in D00 D02 D05 D07 D15 D80; do 
  num=$(intersectBed -a $TF/${TF}_peaks.narrowPeak -b ../../atac/peaks/${day}.ATAC.truepeak.filtered.narrowPeak -u |wc -l)
  echo -e "$TF\t$day\t$num" >> TF_overlap_ATAC.summary
  done
done


#H3K27ac
> TF_overlap_H3K27ac.summary
for TF in TBX5 NKX2.5 GATA4 MEF2C; do
  echo -e "$TF\t$(wc -l $TF/${TF}_peaks.narrowPeak)"  >> TF_overlap_H3K27ac.summary
  for day in D00 D02 D05 D07 D15 D80; do
  num=$(intersectBed -a $TF/${TF}_peaks.narrowPeak -b ../../chipseq/peaks/H3K27ac_${day}/pooled/trurep_peaks.filtered.narrowPeak -u |wc -l)
  echo -e "$TF\t$day\t$num" >> TF_overlap_H3K27ac.summary
  done
done

