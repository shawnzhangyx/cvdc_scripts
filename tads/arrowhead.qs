#!/bin/bash
#PBS -q home
#PBS -N tads
#PBS -l nodes=1:ppn=1
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m abe
#PBS -A ren-group
##PBS -t 7,9,11,12
#PBS -t 1-6,8,10
cd /oasis/tscc/scratch/shz254/projects/cardiac_dev/hic/juicer/
name=$(ls *.hic|sed -n ${PBS_ARRAYID}p | sed -e 's/.hic//')
java  -Xms3072m -Xmx3072m -jar /home/shz254/software/hic/juicebox_tools.7.0.jar arrowhead $name.hic ../tads/$name.tads &> ../tads/$name.log -r 10000

