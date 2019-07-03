#!/bin/bash

#PBS -q hotel
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=8,pmem=4gb,walltime=24:00:00
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m abe
#PBS -A ren-group
#PBS -j oe

cd /oasis/tscc/scratch/shz254/projects/cardiac_dev/
Rscript /home/shz254/projects/cardiac_dev/scripts/promoter_anchored_interaction/promoter_anchored.local_interaction.r \
    data/hic/matrix/$sample/${chr}_10000.txt \
    analysis/promoterAnchoredInteractions/raw_local_sig_tests/${sample}.${chr}.txt \
    analysis/promoterAnchoredInteractions/10k_bins/${chr}_bins.txt 

