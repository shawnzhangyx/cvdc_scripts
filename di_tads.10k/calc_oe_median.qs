#!/bin/bash

#PBS -q hotel
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=12,pmem=4gb,walltime=24:00:00
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m abe
#PBS -A ren-group
#PBS -j oe

cd /projects/ps-renlab/yanxiao/projects/cardiac_dev/scripts/di_tads.10k/
Rscript ../utility/calc_oe_median.r ../../analysis/di_tads.10k/boundaries/boundary.all.txt ${day}_HiC_${rep} ../../analysis/di_tads.10k/oe_median/ &> ../../analysis/di_tads.10k/oe_median/${day}_HiC_${rep}.log

