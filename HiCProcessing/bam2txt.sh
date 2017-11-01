#!/bin/bash

#PBS -q pdafm 
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=6,walltime=72:00:00
#PBS -V
#PBS -M shz254@ucsd.edu
#PBS -m ae
#PBS -A ren-group
#PBS -j oe
#PBS -t 98,101,105,106,109
##PBS -t 108
cd /oasis/tscc/scratch/shz254/projects/cardiac_dev/data/hic/mapping/bams
BIN=/home/shz254/Pipelines/hic-pipeline/bin
ID=SP${PBS_ARRAYID}
mkdir $ID
samtools view $ID.GATC.bam | /home/shz254/Pipelines/hic-pipeline/bin/sam2hic.pl | \
awk '{if ($3<$7) print $3$7,$0; else print $7$3,$0}' | \
$BIN/sort -T $ID --parallel=6 -S 80G | \
cut -d ' ' -f 2- | awk '{ if (NR%2==1)print $0}'| gzip > $ID.juicer.txt.gz


#java -Xms49152m -Xmx49152m -jar /oasis/tscc/scratch/bil022/HiC/bin/Juicebox.jar pre -q 30 -f /oasis/tscc/scratch/bil022/HiC/bin/juicebox/site_pos/hg19_GATC.txt $ID.hic.txt.gz $ID.hic hg19 &> ${ID}.juicebox_pre.log


