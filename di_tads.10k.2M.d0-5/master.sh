mkdir -p ../../analysis/di_tads.10k.2M.d0-5/di_tads
for file in ../../data/hic/DI/D0{0,2,5}_*.10000.200.DI.bedGraph.TAD; do
  name=$(basename $file)
  echo $name 
  ln $file ../../analysis/di_tads.10k.2M.d0-5/di_tads/$name.bed
  done
## merge tad boundaries. 
#rm combined_tads.raw.sorted.txt
#for file in $(ls di_tads/D??_HiC_Rep?.*.TAD.bed); do
#  awk -v OFS="\t" -v name=${file/di_tads\/} '{ if(NR>1) print $0,name}' $file
#    done |sort --parallel=4 -k1,1 -k2,2n -k3,3n - >> combined_tads.raw.sorted.txt


## replicated TAD boundaries 
cd ../../analysis/di_tads.10k.2M.d0-5
mkdir boundaries DI_quantile boundary_DI_overlaps dynamic_bd
for file in di_tads/*.bed; do
file2=$(basename $file)
name=${file2/.10000.200.DI.bedGraph.TAD.bed/}
echo $name
awk -v OFS="\t" -v name=$name '{print $1,$2,name"\n"$1,$3,name}' $file |sort -k1,1 -k2,2n > boundaries/$name.boundary 
done
sort -k1,1 -k2,2n -m boundaries/D*.boundary > boundaries/boundary.all.txt

cd - 
Rscript merge_tad_boundary_across_stages.r 
Rscript normalize_DI_scores.r

cd ../../analysis/di_tads.10k.2M.d0-5
# overlap TAD boundary with DI score.
for sample in $(cat ../../data/hic/meta/names.txt|sed -n 1,6p ); do
  echo $sample
  intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-50000 <0){print $1,0,$2+50000,$1":"$2 } else {print $1,$2-50000,$2+50000,$1":"$2 }}' boundaries/combined_boundary.uniq.txt ) \
      -b DI_quantile/${sample}.10000.200.DI.bedGraph \
  -wo > boundary_DI_overlaps/${sample}.DI.overlap.txt
  done
Rscript calc_DI_delta.r

Rscript define_boundary_by_DI_delta.r
Rscript find_dynamic_boundary_DI_delta.r

# plot the TAD number
Rscript plotTadNumber.r
Rscript plotTadSize.r


## overlap with repeats
bash D00.overlap_tad_boundary_to_repeats.sh
Rscript D00.repeats.enrichment.r
