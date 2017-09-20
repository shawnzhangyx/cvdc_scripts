#!/bin/bash

#PBS -q hotel
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=8,pmem=4gb,walltime=48:00:00
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m ae
#PBS -A ren-group
#PBS -j oe
#PBS -t 1-21,23 

if [ $PBS_ARRAYID -eq 23 ] ; then 
    chr=X
else 
  chr=$PBS_ARRAYID
fi
cd /projects/ps-renlab/yanxiao/projects/cardiac_dev/analysis/customLoops/


#Rscript ../../scripts/customLoops/test.main.region.r ../../data/hic/matrix_raw/D00_HiC_Rep1/${chr}_10000.txt chr${chr}.d00.rep1.txt ../../data/hic/matrix/D00_HiC_Rep1/${chr}_10000.txt 181400000 181700000
Rscript ../../scripts/customLoops/test.main.r ../../data/hic/matrix_raw/$name/${chr}_10000.txt tests_sample_chr/chr${chr}.$name.txt ../../data/hic/matrix/$name/${chr}_10000.txt 
