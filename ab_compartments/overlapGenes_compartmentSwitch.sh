cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/ab_compartments/clusters
intersectBed -a ~/annotations/hg19/gencode.v19.annotation.transcripts.tss10k.bed -b top500_increase.bed -u | uniq -f 3 |cut -f 4 > genes_overlap_increase.txt 
intersectBed -a ~/annotations/hg19/gencode.v19.annotation.transcripts.tss10k.bed -b top500_decrease.bed -u | uniq -f 3 |cut -f 4 > genes_overlap_decrease.txt

join <(sort -k 1 genes_overlap_increase.txt) <(sort -k 1 ../../../data/rnaseq/gene.rpkm.txt) -t $'\t' > gene_increase_rpkm.txt

join <(sort -k 1 genes_overlap_decrease.txt) <(sort -k 1 ../../../data/rnaseq/gene.rpkm.txt) -t $'\t' > gene_decrease_rpkm.txt

