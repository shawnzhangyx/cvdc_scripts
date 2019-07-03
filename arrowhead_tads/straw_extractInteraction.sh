mkdir -p ../../analysis/tads/contacts_by_samples/
#sample=../../data/hic/juicer/D00_HiC_Rep1.hic 
for name in $(cat ../../data/hic/meta/names.txt);do 
sample=../../data/hic/juicer/${name}.hic

## 10kb 
echo $name 
echo -e "chr\tx1\tx2\ty1\ty2\tcontacts" | tee \
  ../../analysis/tads/contacts_by_samples/$name.contacts.within.txt \
  ../../analysis/tads/contacts_by_samples/$name.contacts.pre.txt \
  ../../analysis/tads/contacts_by_samples/$name.contacts.pos.txt

tail -n +2  ../../analysis/tads/combined_tads.uniq.gt1.txt |
while read chr1 x1 x2 chr2 y1 y2 field4; do
  mid=$(( x2/2 + x1/2 ))
  len=$(( x2/2 - x1/2 ))
  pre=$(( x1 - len ))
  pos=$(( x2 + len ))
#  if [ -z "$contact" ]; then contact=0;fi 
#  echo -e "$(../utility/straw KR $sample chr$chr1:$x1:$x2 chr$chr2:$y1:$y2 BP 10000 | awk -v chr=$chr1 -v x1=$x1 -v x2=$x2 -v OFS="\t" '{print chr,x1,x2,$0}')" \
  echo -e "$(../utility/straw KR $sample $chr1:$x1:$mid $chr2:$mid:$x2 BP 10000 | awk -v chr=$chr1 -v x1=$x1 -v x2=$x2 -v OFS="\t" '{print chr,x1,x2,$0}')" \
  >> ../../analysis/tads/contacts_by_samples/$name.contacts.within.txt
  echo -e "$(../utility/straw KR $sample $chr1:$pre:$x1 $chr2:$x1:$mid BP 10000 | awk -v chr=$chr1 -v x1=$x1 -v x2=$x2 -v OFS="\t" '{print chr,x1,x2,$0}')" \
    >> ../../analysis/tads/contacts_by_samples/$name.contacts.pre.txt
  echo -e "$(../utility/straw KR $sample $chr1:$mid:$x2 $chr2:$x2:$pos BP 10000 | awk -v chr=$chr1 -v x1=$x1 -v x2=$x2 -v OFS="\t" '{print chr,x1,x2,$0}')" \
    >> ../../analysis/tads/contacts_by_samples/$name.contacts.pos.txt

    done &

done 
wait
#for name in $(cat ../../data/hic/meta/names.txt);do
for file in contacts_by_samples/*.{within,pre,pos}.txt; do 
echo $file
#Rscript ../../scripts/tads/sum_tad_counts_each_sample.r $file $file.sum &
Rscript ../../scripts/tads/sum_tad_counts_each_sample.r $file $file.median &

done
wait
#Rscript merge_tad_counts_across_stages.r
