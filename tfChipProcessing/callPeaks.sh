pushd ../../data/tfChIPseq

day=D80
macs2 callpeak -t bam/CTCF_D80_Rep1.bam -c ../chipseq/bams/Input_${day}.merged.bam -n ${day} --outdir peaks/CTCF_${day}/ --tempdir peaks/CTCF_${day} --nomodel --extsize 180 
#for day in D00 D02 D07 D15; do 
#mkdir -p peaks/CTCF_${day}
#macs2 callpeak -t bam/CTCF_${day}_merged.bam -c ../chipseq/bams/Input_${day}.merged.bam -n ${day} --outdir peaks/CTCF_${day}/merged --tempdir peaks/CTCF_${day} --nomodel --extsize 180 &
#done
for name in TBX5 NKX2.5 GATA4 MEF2C; do
mkdir peaks/$name/
macs2 callpeak -t bam/${name}.seb1.bam -c bam/Input.seb1.bam -n $name --outdir peaks/$name/ --tempdir peaks/$name --nomodel --extsize 180 &
done

name=GATA4
macs2 callpeak -t bam/${name}.seb2.bam -c bam/Input.seb1.bam -n $name --outdir peaks/$name/ --tempdir peaks/$name --nomodel --extsize 180 



## PePr peaks
