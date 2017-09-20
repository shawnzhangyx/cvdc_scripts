#!/bin/bash

#PBS -q hotel
#PBS -N yanxiao_job
#PBS -l nodes=1:ppn=1,pmem=4gb,walltime=48:00:00
#PBS -V
#PBS -M yanxiazh@umich.edu
#PBS -m abe
#PBS -A ren-group
#PBS -j oe
#PBS -t 1-12

cd /projects/ps-renlab/yanxiao/projects/cardiac_dev/analysis/tads/
name=$(sed -n "${PBS_ARRAYID}p" ../../data/hic/meta/names.txt)
echo $name
sample=../../data/hic/juicer/${name}.hic
> oe/$name.oe.txt
tail -n +2  combined_tads.uniq.txt |
while read chr1 x1 x2 field4; do
java -jar -Xmx4G /home/shz254/software/hic/juicebox/juicebox_tools.7.0.jar dump oe KR $sample chr$chr1:$x1:$x2 chr$chr1:$x1:$x2 BP 10000 oe/$name.tmp && awk -v chr=$chr1 -v x1=$x1 -v x2=$x2 -v OFS="\t" '{print chr,x1,x2,$0}' oe/$name.tmp >> oe/$name.oe.txt
done
