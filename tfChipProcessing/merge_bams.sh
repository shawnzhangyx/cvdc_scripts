pushd ../../data/ctcf/bam/

for day in D00 D02 D07 D15; do
(
#samtools merge -f CTCF_${day}_merged.bam CTCF_${day}_Rep1.bam CTCF_${day}_Rep2.bam 
#samtools index CTCF_${day}_merged.bam 
samtools merge -f Input_${day}_merged.bam Input_${day}_Rep1.bam Input_${day}_Rep2.bam
) &
done

