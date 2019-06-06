mkdir -p  ../../analysis/hervh_ki/hic_bam_for_phase/

awk '{start=$2-2000000; if ($2-2000000 < 0) {start=0} print $1":"start"-"$2+2000000 }' hervh_ins.txt > ../../analysis/hervh_ki/hic_bam_for_phase/hervh_ins.ext2M.txt


## extract the bam files. 
for line in $(cat ../../analysis/hervh_ki/hic_bam_for_phase/hervh_ins.ext2M.txt); do
  (
  for sample in $(cat ../../data/hic/meta/names.txt); do
    sample=${sample/_HiC/}
    echo $line, $sample
    samtools view -b ../../data/hic/bams/$sample.bam $line > ../../analysis/hervh_ki/hic_bam_for_phase/$line.$sample.bam
    done
  ) &
  done

## merge the bam files. 
for line in $(cat ../../analysis/hervh_ki/hic_bam_for_phase/hervh_ins.ext2M.txt); do
  samtools merge -f ../../analysis/hervh_ki/hic_bam_for_phase/$line.merge.bam \
  ../../analysis/hervh_ki/hic_bam_for_phase/$line.D??_Rep?.bam &
  done

## phase RNA-seq reads
chr=chr7

for chr in chr9 chr12 chr20 chr1 chr17; do 
python2 split_allele_lu.py -b ../../data/herv-ki/rnaseq/bam/KI2.bam -v ../../analysis/hervh_ki/luisa_phasing/$chr/H9.${chr}.liftover_clean2.vcf -o ../../analysis/hervh_ki/rna/${chr}_KI2 2> ../../analysis/hervh_ki/rna/${chr}_KI2_err &
done

## featureCounts. 
cd ../../analysis/hervh_ki/rna
for chr in chr9 chr12 chr20 chr17; do
featureCounts -a ~/Pipelines/rnaseq/annotation/gtf/gencode.v19.annotation.gtf -o $chr.counts ${chr}_KI2Aallele.bam ${chr}_KI2Ballele.bam -F GTF -T 8 -t exon -g gene_name &
done
