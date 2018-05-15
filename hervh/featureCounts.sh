cd ../../analysis/hervh
bwDir=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/trackhub/hg19

day=D00
for day in D00 D02 D05 D07 D15 D80; do 
~/software/ucsc/bigWigAverageOverBed $bwDir/rnaseq_${day}.rpkm.bw hervh.ext1k.bed rnaseq/rnaseq_${day}.out -minMax &
done

day=D00
for day in D02; do
~/software/ucsc/bigWigAverageOverBed $bwDir/rnaseq_${day}.rpkm.bw <(cut -f 1-4 D00.rna_seq.ranked_by_rpkm.bed) rnaseq/all_gene.rnaseq_${day}.out -minMax 
done
