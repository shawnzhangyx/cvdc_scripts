pushd ../../analysis/gWAS/
intersectBed -a ../../data/atac/peaks/atac_merged_peaks.bed -b ../../data/gWAS/heartGWAS.LD_SNP.bed -wo > gWAS.overlap_atac.txt
intersectBed -a ../../data/atac/peaks/atac_distal_peaks.bed -b ../../data/gWAS/heartGWAS.LD_SNP.bed -wo > gWAS.overlap_atac_distal.txt
sort -k4,4 -u gWAS.overlap_atac_distal.txt > gWAS.overlap_atac_distal.uniq.txt
intersectBed -a gWAS.overlap_atac_distal.uniq.txt -b ../../data/chipseq/merged_peaks/H3K27ac_merged_peaks.bed -u > gWAS.overlap_atac_distal.uniq.overlap_H3K27ac_peaks.txt

#intersectBed -a gWAS.overlap_atac_distal.uniq.overlap_H3K27ac_peaks.txt -b <(tail -n +2 ../hiccup_loops/combined_loops.uniq.txt ) -wb > gWAS.overlap_atac_distal.uniq.overlap_H3K27ac_peaks.overlap_hiccup_anchor1.txt
#intersectBed -a gWAS.overlap_atac_distal.uniq.overlap_H3K27ac_peaks.txt -b <(tail -n +2 ../hiccup_loops/combined_loops.uniq.txt|awk -v OFS="\t" '{print $4,$5,$6,$1,$2,$3,$7}' ) -wb > gWAS.overlap_atac_distal.uniq.overlap_H3K27ac_peaks.overlap_hiccup_anchor2.txt

### annotate overlaps with loop information and target gene.
#Rscript annotate_GWAS_overlaps.r

