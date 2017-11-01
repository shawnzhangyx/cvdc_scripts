#!/bin/bash

#PBS -q pdafm 
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=4,walltime=48:00:00
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m ae
#PBS -A ren-group
#PBS -j oe
##PBS -t 00,02,05,07
#PBS -t 00 
cd /oasis/tscc/scratch/shz254/projects/cardiac_dev/data/hic/mapping/

ID=D0${PBS_ARRAYID}.combined
#java -Xms49152m -Xmx49152m -jar /oasis/tscc/scratch/bil022/HiC/bin/Juicebox.jar pre -q 30 -f /oasis/tscc/scratch/bil022/HiC/bin/juicebox/site_pos/hg19_GATC.txt $ID.juicer.txt.gz $ID.hic hg19 &> ${ID}.juicebox_pre.log
java -Xms49152m -Xmx49152m -jar /oasis/tscc/scratch/bil022/HiC/bin/Juicebox.jar pre -q 30 -f /oasis/tscc/scratch/bil022/HiC/bin/juicebox/site_pos/hg19_GATC.txt valid_pairs/$ID.juicer.txt.gz juicer/$ID.hic hg19 &> logs/${ID}.juicebox_pre.log


