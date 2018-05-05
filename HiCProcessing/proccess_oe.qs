#!/bin/bash

#PBS -q hotel
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=8,pmem=4gb,walltime=24:00:00
#PBS -V
#PBS -M shz254@ucsd.edu
#PBS -m abe
#PBS -A ren-group
#PBS -j oe
#PBS -t 1-12 

cd /projects/ps-renlab/yanxiao/projects/cardiac_dev/scripts/HiCProcessing/
sample=$(sed -n ${PBS_ARRAYID}p ../../data/hic/meta/names.txt)
for chr in {1..22..1} X; do
Rscript proccess_oe.r $chr 2e5 $sample
done

