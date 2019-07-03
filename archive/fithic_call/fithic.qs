#!/bin/bash

#PBS -q hotel 
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=1,pmem=4gb,walltime=24:00:00
#PBS -V
#PBS -M shz254@ucsd.edu
#PBS -m abe
#PBS -A ren-group
#PBS -j oe

python $HOME/software/hic/fithic/bin/fit-hi-c.py -f $frag -i $interaction -o $out -l ${chr}.norm -b 200 -L 15000 -U 2000000
