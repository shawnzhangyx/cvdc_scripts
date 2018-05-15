mkdir ../../analysis/di_tads.10k/di_tads
for file in ../../data/hic/DI/*.TAD; do
  name=$(basename $file)
  echo $name 
  ln $file ../../analysis/di_tads.10k/di_tads/$name.bed
  done
## merge tad boundaries. 
for file in $(ls di_tads/D??_HiC_Rep?.*.TAD.bed); do
  awk -v OFS="\t" -v name=${file/di_tads\/} '{ if(NR>1) print $0,name}' $file
    done |sort --parallel=4 -k1,1 -k2,2n -k3,3n - >> combined_tads.raw.sorted.txt

Rscript merge_tads_across_stages.r
## replicated TAD boundaries 
mkdir boundaries
cut -f 1,2 combined_tads.uniq.gt1.txt |tail -n +2 > boundaries/boundary.1.txt
cut -f 1,3 combined_tads.uniq.gt1.txt |tail -n +2 > boundaries/boundary.2.txt
cat boundaries/boundary.1.txt boundaries/boundary.2.txt|sort -k1,1 -k2,2n -u > boundaries/boundary.all.txt

# overlap TAD boundary with DI score.
for sample in $(cat ../../data/hic/meta/names.txt); do
  echo $sample
  intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-100000 <0){print $1,0,$2+100000,$1":"$2 } else {print $1,$2-100000,$2+100000,$1":"$2 }}' boundaries/boundary.all.txt ) \
    -b ../../data/hic/DI/${sample}.10000.50.DI.bedGraph \
  -wo > boundaries/${sample}.DI.overlap.txt
  done
Rscript calc_DI_delta.r

# plot the TAD number
Rscript plotTadNumber.r
Rscript plotTadSize.r
