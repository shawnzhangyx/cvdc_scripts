
chr=chr19
bin_size=50000
chr_size=$(awk -v chr=$chr '{{if($1==chr)print $2}}' /mnt/silencer2/share/bowtie_indexes/hg19.fa.fai)
sample=SP98

~/Pipelines/hic/scripts/pairs2mat.awk -v chr=$chr -v bin_size=$bin_size \
  -v chr_size=$chr_size <(zcat ${sample}.juicer.txt.gz ) > \
 ../asc/${sample}.${chr}.${bin_size}.asc

