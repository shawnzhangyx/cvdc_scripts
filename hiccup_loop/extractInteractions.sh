
outdir=../../analysis/hiccup_loops/contacts_by_chr/
mkdir -p $outdir

for chr in {22..1} X; do
  echo $chr
  contacts=$(ls ../../data/hic/matrix_raw/*/${chr}_*)
  loop=../../analysis/hiccup_loops/loops_merged_across_samples.uniq.tab
  out=$outdir/loops_merged.${chr}.mat.txt
  python /mnt/silencer2/home/yanxiazh/software/github/hic-kit/extractContactFrequency.py --loop $loop --out-file $out --chr chr$chr --contact-file $contacts &
  done
wait

for chr in {22..1} X; do
  echo $chr
  contacts=$(ls ../../data/hic/observed_expected/*/${chr}_*)
  loop=../../analysis/hiccup_loops/loops_merged_across_samples.uniq.tab
  out=$outdir/loops_merged.${chr}.oe.txt
  python /mnt/silencer2/home/yanxiazh/software/github/hic-kit/extractContactFrequency.py --loop $loop --out-file $out --chr chr$chr --contact-file $contacts &
  done
wait 

head -n 1 $outdir/loops_merged.1.mat.txt |awk -v OFS="\t" '{print "chr",$0}' > $outdir/../loops_merged.observed.txt
head -n 1 $outdir/loops_merged.1.oe.txt |awk -v OFS="\t" '{print "chr",$0}' > $outdir/../loops_merged.oe.txt
for chr in {1..22} X; do
   awk -v OFS="\t" -v chr=$chr '{ if(NR>1) print  "chr"chr,$0}' $outdir/loops_merged.${chr}.mat.txt >>  $outdir/../loops_merged.observed.txt
   awk -v OFS="\t" -v chr=$chr '{ if(NR>1) print  "chr"chr,$0}' $outdir/loops_merged.${chr}.oe.txt >> $outdir/../loops_merged.oe.txt
done
#tail -n +2 -q $outdir/loops_merged.*.mat.txt >> $outdir/../loops_merged.mat.txt
#tail -n +2 -q $outdir/loops_merged.*.oe.txt >> $outdir/../loops_merged.oe.txt

