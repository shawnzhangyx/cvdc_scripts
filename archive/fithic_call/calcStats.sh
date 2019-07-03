outdir=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/fithic/results
for name in $(cat ../../data/hic/meta/names.txt)
  do
  echo $name $(cat $outdir/$name/q0.01/*.txt| wc -l) >>  $outdir/summary.stats
  done
