join -1 4 <(sort -k4,4  hglft_genome_65a_d80910.bed -u )  \
          <(sort -k1,1 GWAS_Catolog_all_09282017.red.tsv ) -t $'\t' > GWAS_Catolog_hg19.txt

## LD SNP
join -1 5 <(sort -k5,5 LD_SNP_SNAP.hg19.red.bed )  \
          <(sort -k1,1 GWAS_Catolog_all_09282017.red.tsv ) -t $'\t' > GWAS_Catolog.LD.SNP.hg19.txt
