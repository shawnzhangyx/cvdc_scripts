#!/bin/bash

#PBS -q pdafm
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=1,walltime=24:00:00
#PBS -V
#PBS -M shz254@ucsd.edu
#PBS -m ae
#PBS -A ren-group
#PBS -j oe

cd /projects/ps-renlab/yanxiao/projects/cardiac_dev/scripts/HiCProcessing/

Rscript mat2di.r ../../data/hic/table2x2/$sample/chr${chr}.tab.gz $chr $bin_size $bin_num ../../data/hic/DI/$sample/chr${chr}.${bin_size}.${bin_num}.DI.bedGraph

