#!/bin/bash

#PBS -q hotel
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=4,pmem=4gb,walltime=72:00:00
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m abe
#PBS -A ren-group
#PBS -t 1-50

module load pysam

cd /oasis/tscc/scratch/shz254/projects/cardiac_dev/hic/

#name=""
seq=$(printf "%04d\n" $(($PBS_ARRAYID -1)) )
python /home/serein/scripts/HiC/juicer/sam2juicer.py -s mapping/${name}_tmp/${name}.${seq}.sam -f /home/shz254/genomes/hic/MboI/hg19_MboI.txt | awk '{gsub("chr","",$2) ; gsub("chr","",$6) ; print}' | sort -S 12G --parallel=4 -T mapping/${name}_tmp -k2,2d -k6,6d -k4,4n -k8,8n -k1,1n -k5,5n -k3,3n - >mapping/${name}_tmp/${name}.${seq}.sort.txt
