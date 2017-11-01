#!/bin/bash
#PBS -q gpu-hotel
#PBS -N hiccups_merged
#PBS -l nodes=1:ppn=3
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m abe
#PBS -A ren-group
#PBS -t 98-109
module load cuda
cd /oasis/tscc/scratch/shz254/projects/cardiac_dev/data/hic/mapping/juicer/
name=SP${PBS_ARRAYID}
java -Djava.awt.headless=true -Djava.library.path=/home/shz254/software/hic/native_launcher/natives/ -Xmx12288m -Xms12288m -jar /home/shz254/software/hic/juicebox/juicebox_tools.7.0.jar hiccups -k KR -r 10000 $name.hic final_loops/${name} final_loops/uniq_loops.final.for_hiccups.txt &> final_loops/$name.log 
