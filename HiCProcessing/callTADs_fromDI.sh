cd ../../data/hic/DI/
for sample in $(cat ../meta/names.txt|tail -n +2); do
echo $sample
#~/Pipelines/hic/lib/DI2TAD.sh ${sample}.10000.50.DI.bedGraph /mnt/tscc/share/bowtie_indexes/hg19 10000 >& ${sample}.log &
~/Pipelines/hic/lib/DI2TAD.sh ${sample}.10000.200.DI.bedGraph /mnt/tscc/share/bowtie_indexes/hg19 10000 >& ${sample}.log &
done
