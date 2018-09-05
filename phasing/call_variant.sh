cd ../../analysis/phasing/MSX1/
samtools mpileup -uf /projects/ps-renlab/share/bowtie_indexes/hg19.fa MSX1.combined.raw.bam | bcftools view -bvcg - > var.raw.bcf  
bcftools view var.raw.bcf | vcfutils.pl varFilter -D100 > var.flt.vcf  

