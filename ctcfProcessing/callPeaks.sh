pushd ../../data/ctcf/

for day in D00 D02 D07 D15; do 
mkdir -p peaks/CTCF_${day}
macs2 callpeak -t bam/CTCF_${day}_merged.bam -c ../chipseq/bams/Input_${day}.merged.bam -n ${day} --outdir peaks/CTCF_${day}/merged --tempdir peaks/CTCF_${day} --nomodel --extsize 180 &
done

