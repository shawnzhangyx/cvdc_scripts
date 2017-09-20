for sample in $(cat ../../data/hic/meta/names.txt); do
  (
  for chr in {1..22} X; do 
    echo $sample $chr
    Rscript remove_pixel_wo_nearby.r ../../analysis/customLoops/tests_sample_chr/chr${chr}.${sample}.txt 
    Rscript colapse_pixels.r ../../analysis/customLoops/tests_sample_chr/chr${chr}.${sample}.txt.removed 
  done
  ) &
  done
