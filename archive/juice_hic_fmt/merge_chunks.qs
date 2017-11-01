#!/bin/bash

#PBS -q pdafm
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=8,pmem=16gb,walltime=72:00:00
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m abe
#PBS -A ren-group
#PBS -t 1-12 

cd /oasis/tscc/scratch/shz254/projects/cardiac_dev/hic/
name=$(sed -n ${PBS_ARRAYID}p ~/projects/cardiac_dev/hic/meta/sample_name.txt)
sort -m -S 110G --parallel=8 -T mapping/${name}_tmp -k2,2d -k6,6d -k4,4n -k8,8n -k1,1n -k5,5n -k3,3n `ls mapping/${name}_tmp/*.txt` | gzip > juicer/$name.sorted.gz

#sort -m -S 120G --parallel=8 -T tmp -k2,2d -k6,6d -k4,4n -k8,8n -k1,1n -k5,5n -k3,3n tmp/test.0000.sort.txt tmp/test.0001.sort.txt tmp/test.0002.sort.txt tmp/test.0003.sort.txt tmp/test.0004.sort.txt tmp/test.0005.sort.txt tmp/test.0006.sort.txt tmp/test.0007.sort.txt tmp/test.0008.sort.txt tmp/test.0009.sort.txt tmp/test.0010.sort.txt tmp/test.0011.sort.txt tmp/test.0012.sort.txt tmp/test.0013.sort.txt tmp/test.0014.sort.txt tmp/test.0015.sort.txt tmp/test.0016.sort.txt tmp/test.0017.sort.txt tmp/test.0018.sort.txt tmp/test.0019.sort.txt tmp/test.0020.sort.txt tmp/test.0021.sort.txt tmp/test.0022.sort.txt tmp/test.0023.sort.txt tmp/test.0024.sort.txt tmp/test.0025.sort.txt tmp/test.0026.sort.txt tmp/test.0027.sort.txt tmp/test.0028.sort.txt tmp/test.0029.sort.txt tmp/test.0030.sort.txt tmp/test.0031.sort.txt tmp/test.0032.sort.txt tmp/test.0033.sort.txt tmp/test.0034.sort.txt tmp/test.0035.sort.txt tmp/test.0036.sort.txttmp/test.0037.sort.txt tmp/test.0038.sort.txt tmp/test.0039.sort.txt tmp/test.0040.sort.txt tmp/test.0041.sort.txt tmp/test.0042.sort.txt tmp/test.0043.sort.txt tmp/test.0044.sort.txt tmp/test.0045.sort.txt tmp/test.0046.sort.txt tmp/test.0047.sort.txt tmp/test.0048.sort.txt tmp/test.0049.sort.txt | gzip >juicer/test.txt.sorted.gz

