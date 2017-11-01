grep -v WARNING LD_SNP_SNAP.txt |grep -v "N/A" |awk -v OFS="\t" '{if ( NR>1 ) print $7,$8-1,$8+1,$2,$1}' |sort -u > LD_SNP_SNAP.hg18.red.bed
# convert hg18 to hg19. 
Rscript convert_csv_to_bed.r
Rscript extract_heart_gwas_SNPs.r
#
bash overlap_with_ATAC.sh
bash overlap_with_loops.sh



## convert the list from Hongbo to bed format.
