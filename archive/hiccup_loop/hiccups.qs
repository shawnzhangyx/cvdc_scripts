#!/bin/bash
#PBS -q gpu-hotel
#PBS -N hiccups
#PBS -l nodes=1:ppn=3
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m abe
#PBS -A ren-group
##PBS -t 1-12
#PBS -t 3
module load cuda
cd /oasis/tscc/scratch/shz254/projects/cardiac_dev/hic/juicer/
name=$(ls *.hic|sed -n ${PBS_ARRAYID}p | sed -e 's/.hic//')
java -Djava.awt.headless=true -Djava.library.path=/home/shz254/software/hic/native_launcher/natives/ -Xmx12288m -Xms12288m -jar /home/shz254/software/hic/juicebox_tools.7.0.jar hiccups $name.hic ../loops/$name.loop &> ../loops/$name.log

