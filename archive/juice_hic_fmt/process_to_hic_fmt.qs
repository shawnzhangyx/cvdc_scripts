#!/bin/bash

#PBS -q pdafm
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=4,pmem=16gb,walltime=72:00:00
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -j oe
#PBS -m abe
#PBS -A ren-group
#PBS -t 2-12 


cd /oasis/tscc/scratch/shz254/projects/cardiac_dev/hic/
name=$(sed -n ${PBS_ARRAYID}p ~/projects/cardiac_dev/hic/meta/sample_name.txt)
if [ ! -d juicer/$name ]; then mkdir juicer/$name; fi 

java -Duser.home=juicer/$name/tmp -Djava.awt.headless=true -Xms49152m -Xmx49152m -jar /home/shz254/software/hic/juicebox_tools.7.0.chrM.jar pre juicer/$name.sorted.gz juicer/$name/$name.hic hg19 -f /home/shz254/genomes/hic/MboI/hg19_MboI.txt -q 10 &>juicer/log/${name}.juicebox_pre.log
