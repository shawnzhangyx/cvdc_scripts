chr=chr20
bin_num=10
bin_size=10000

SCP=/mnt/silencer2/home/shz254/Pipelines/hic/scripts/
chr_size=$(awk -v chr=$chr '{{if($1==chr)print $2}}' /projects/ps-renlab/share/bowtie_indexes/hg19.fa.fai)


sample=HERV-KI2
sample=HERV-KO
$SCP/col2mat.awk -v chr=$chr -v bin_size=10000 -v chr_size=$chr_size ../../analysis/hervh_ki/matrix_norm/$sample.$chr.10k.mat \
    > ../../analysis/hervh_ki/matrix_norm/${sample}.${chr}.norm.asc

# matrix to directionality index
Rscript $SCP/asc2di.R ../../analysis/hervh_ki/matrix_norm/$sample.$chr.norm.asc $chr $bin_size $bin_num \
      ../../analysis/hervh_ki/matrix_norm/${sample}.$chr.$bin_num.norm.DI.bedGraph

