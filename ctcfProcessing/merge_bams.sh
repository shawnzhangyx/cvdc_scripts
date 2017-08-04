pushd ../../data/ctcf/bam/

for day in D00 D02 D07 D15; do
#samtools merge CTCF_${day}_merged.bam CTCF_${day}_Rep1.bam CTCF_${day}_Rep2.bam &
samtools index CTCF_${day}_merged.bam &
done

