#!/bin/bash

#PBS -q pdafm
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=16,pmem=16gb,walltime=72:00:00
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m abe
#PBS -A ren-group
#PBS -j oe


cd /oasis/tscc/scratch/shz254/projects/cardiac_dev/hic/
sort -m --parallel=16 -T mapping/tmp -k2,2d -k6,6d -k4,4n -k8,8n -k1,1n -k5,5n -k3,3n `ls mapping/*/*.txt` | gzip > juicer/all_combined.sorted.txt.gz
#sort -m -S 130G --parallel=16 -T mapping/tmp -k2,2d -k6,6d -k4,4n -k8,8n -k1,1n -k5,5n -k3,3n `ls mapping/*/*.txt` | gzip > juicer/all_combined.sorted.txt.gz


