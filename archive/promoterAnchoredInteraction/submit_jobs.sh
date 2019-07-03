# find significant promoter interactions
#sample=D00_HiC_Rep1
#chr=22
for sample in $(cat /oasis/tscc/scratch/shz254/projects/cardiac_dev/data/hic/meta/names.txt);do
  for chr in {1..10}; do
    echo $sample
    qsub -N ${sample}.${chr} -v sample=${sample},chr=${chr} job_script.qs 
  done
done
