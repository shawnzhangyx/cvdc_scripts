#!/bin/bash
#PBS -q gpu-hotel
#PBS -N yanxiao
#PBS -l nodes=1:ppn=3
#PBS -l walltime=48:00:00
#PBS -j oe
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m abe
#PBS -A ren-group
module load cuda
cd /oasis/tscc/scratch/shz254/projects/cardiac_dev/hic/juicer/
#java -Djava.awt.headless=true -Djava.library.path=/home/shz254/software/hic/native_launcher/natives/ -Xmx12288m -Xms12288m -jar /home/shz254/software/hic/juicebox_tools.7.0.jar hiccups $(ls *.hic) ../loops/all_combined.loop &> ../loops/all_combined.log
java -Djava.awt.headless=true -Djava.library.path=/home/shz254/software/hic/native_launcher/natives/ -Xmx12288m -Xms12288m -jar /home/shz254/software/hic/juicebox_tools.7.0.jar hiccups -r 10000 -k KR  D0_HiC_Rep1.hic+D0_HiC_Rep2.hic+D2_HiC_Rep1.hic+D2_HiC_Rep2.hic+D5_HiC_Rep1.hic+D5_HiC_Rep2.hic+D7_HiC_Rep1.hic+D7_HiC_Rep2.hic+D15_HiC_Rep1.hic+D15_HiC_Rep2.hic+D80_HiC_Rep1.hic+D80_HiC_Rep2.hic ../loops/all_combined.loop &> ../loops/all_combined.log


