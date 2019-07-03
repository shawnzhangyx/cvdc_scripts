mkdir -p ../../analysis/hiccup_loops/contacts_by_samples/
#sample=../../data/hic/juicer/D00_HiC_Rep1.hic 
for name in $(cat ../../data/hic/meta/names.txt);do 
sample=../../data/hic/juicer/${name}.hic

## 10kb 
echo $name 
echo -e "chr\tx1\ty1\tcontacts" > \
  ../../analysis/hiccup_loops/contacts_by_samples/$name.contacts.10k.txt
tail -n +2  ../../analysis/hiccup_loops/combined_loops.uniq.txt |
while read chr1 x1 x2 chr2 y1 y2 field4; do
  contact=$(../utility/straw NONE $sample $chr1:$x1:$x1 $chr2:$y1:$y1 BP 10000 |cut -f 3)
  if [ -z "$contact" ]; then contact=0;fi 
  echo -e "$chr1\t$x1\t$y1\t$contact" \
  >> ../../analysis/hiccup_loops/contacts_by_samples/$name.contacts.10k.txt
    done &
## 30kb
#echo -e "chr\tx1\ty1\tx2\ty2\tcontacts" > \
#  ../../analysis/hiccup_loops/contacts_by_samples/$name.contacts.30k.txt
#tail -n +2  ../../analysis/hiccup_loops/combined_loops.hiccup_refined.txt |
#while read chr x1 x2 field4; do
#echo -e "$(../utility/straw NONE $sample $chr:$((x1-10000)):$((x1+10000)) $chr:$((x2-10000)):$((x2+10000)) BP 10000 | awk -v chr=$chr -v x1=$x1 -v x2=$x2 -v OFS="\t" '{print chr,x1,x2,$0}')" \
#>> ../../analysis/hiccup_loops/contacts_by_samples/$name.contacts.30k.txt
#  done &

done 
wait

pushd ../../analysis/hiccup_loops/
echo -e "chr\tx1\ty1\tD00_1\tD00_2\tD02_1\tD02_2\tD05_1\tD05_2\tD07_1\tD07_2\tD15_1\tD15_2\tD80_1\tD80_2" |tee combined_loops.uniq.counts.txt 
paste contacts_by_samples/*.contacts.10k.txt | \
  cut -f 1,2,3,$(seq -s, 4 4 $((4*12)) ) | tail -n +2 >> combined_loops.uniq.counts.txt
#paste contacts_by_samples/*.contacts.30k.txt | \
#  cut -f 1,2,3,$(seq -s, 4 4 $((4*12)) ) | tail -n +2 >> loops_merged.uniq.30k.mat.txt
#popd
