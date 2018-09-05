cd ../../analysis/phasing/
for name in $(cat ../../data/hic/meta/names.txt); do
name=${name/_HiC/}
echo $name
#samtools view ../../data/hic/bams/${name}.bam chr4:4,628,000-4,892,000 -b -o MSX1/$name.bam
samtools view ../../data/hic/bams/${name}.bam chr4:1-6,000,000 -b -o MSX1/$name.bam &
done
wait
bams=$(ls MSX1/D*.bam)
samtools merge -f MSX1/MSX1.combined.raw.bam $bams
samtools index MSX1/MSX1.combined.raw.bam

# copy it from Yunjiang 
tail -n +2 H9.chr4.seed.vcf |awk -v OFS="\t" '{print $1,$2,$2+1,$3}' > H9.chr4.seed.vcf.bed


#samtools view MSX1/MSX1.combined.raw.bam |sort -k1,1 > MSX1/MSX1.combined.sorted_name.sam
#cut -f1 MSX1/MSX1.combined.sorted_name.sam | uniq -d > MSX1/MSX1.dup.name.txt
#join -t"\t"  -2 1 MSX1/MSX1.dup.name.txt MSX1/MSX1.combined.sorted_name.sam > MSX1/MSX1.paired_reads.sam
#
#samtools view -Sb MSX1/MSX1.paired_reads.sam -o MSX1/MSX1.paired_reads.bam

