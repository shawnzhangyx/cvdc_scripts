#!/bin/bash

#PBS -q hotel 
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=1,pmem=4gb,walltime=168:00:00
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m abe
#PBS -A ren-group
##PBS -t 1-4,6-12
#PBS -t 5
cd /oasis/tscc/scratch/shz254/projects/cardiac_dev/hic/

name=$(sed -n ${PBS_ARRAYID}p ~/projects/cardiac_dev/hic/meta/sample_name.txt)
chunk=50
line=$(samtools idxstats mapping/$name.bam | awk 'sum+=$3{print sum}' | tail -n 1)
part=$(echo "($line / 2 + $chunk - 1) / $chunk * 2"|bc)

if [ ! -d mapping/${name}_tmp ]; then  mkdir mapping/${name}_tmp; fi

samtools view -H mapping/$name.bam > mapping/${name}_tmp/test.header
cd mapping/${name}_tmp/
split -da 4 -l $part --filter='cat test.header - > $FILE.sam' ../tmp/$name.name_sorted.sam $name.
rm test.header
