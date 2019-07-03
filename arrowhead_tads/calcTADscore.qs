#!/bin/bash

#PBS -q hotel
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=1,pmem=4gb,walltime=48:00:00
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m abe
#PBS -A ren-group
#PBS -j oe
##PBS -t 1-12
#PBS -t 1,2,6,8
cd /projects/ps-renlab/yanxiao/projects/cardiac_dev/analysis/tads/
name=$(sed -n "${PBS_ARRAYID}p" ../../data/hic/meta/names.txt)
echo $name
sample=../../data/hic/juicer/${name}.hic

java -jar -Xms3G -Xmx3G -jar /home/shz254/software/hic/juicebox/juicebox_tools.7.0.jar arrowhead -r 10000 -k KR $sample arrowhead_test_list/$name combined_tads.uniq.gt1.txt combined_tads.uniq.gt1.txt
