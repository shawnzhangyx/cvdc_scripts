

#D80 302
intersectBed -a <(awk -v OFS="\t" '{print $1,$2-25000,$2+25000}' D80.unique.tads) -b ../../../data/mES_tad/mESC/hglft_genome_2902_c36890.bed -u |wc -l
# 57
intersectBed -a <(awk -v OFS="\t" '{print $1,$3-25000,$3+25000}' D80.unique.tads) -b ../../../data/mES_tad/mESC/hglft_genome_2902_c36890.bed -u |wc -l
# 55

# stable 11096
intersectBed -a <(awk -v OFS="\t" '{print $1,$2-25000,$2+25000}' stable.unique.tads ) -b ../../../data/mES_tad/mESC/hglft_genome_2902_c36890.bed -u |wc -l 
# 2451
intersectBed -a <(awk -v OFS="\t" '{print $1,$3-25000,$3+25000}' stable.unique.tads ) -b ../../../data/mES_tad/mESC/hglft_genome_2902_c36890.bed -u |wc -l
# 2459

#D00 354
intersectBed -a <(awk -v OFS="\t" '{print $1,$2-25000,$2+25000}' D00.unique.tads) -b ../../../data/mES_tad/mESC/hglft_genome_2902_c36890.bed -u |wc -l
# 38 
intersectBed -a <(awk -v OFS="\t" '{print $1,$3-25000,$3+25000}' D00.unique.tads) -b ../../../data/mES_tad/mESC/hglft_genome_2902_c36890.bed -u |wc -l
# 35



### overlap with Bonev mES Hi-C data
#D80 302
intersectBed -a <(awk -v OFS="\t" '{print $1,$2-25000,$2+25000}' D80.unique.tads) -b ../../../data/Bonev_2017_mES_tad/hTAD_boundaries.bed -u |wc -l
#171
intersectBed -a <(awk -v OFS="\t" '{print $1,$3-25000,$3+25000}' D80.unique.tads) -b ../../../data/Bonev_2017_mES_tad/hTAD_boundaries.bed -u |wc -l
#173

#gain 76
intersectBed -a <(awk -v OFS="\t" '{print $1,$2-25000,$2+25000}' gain.unique.tads) -b ../../../data/Bonev_2017_mES_tad/hTAD_boundaries.bed -u |wc -l
#33
intersectBed -a <(awk -v OFS="\t" '{print $1,$3-25000,$3+25000}' gain.unique.tads) -b ../../../data/Bonev_2017_mES_tad/hTAD_boundaries.bed -u |wc -l
#40



# stable 11096
intersectBed -a <(awk -v OFS="\t" '{print $1,$2-25000,$2+25000}' stable.unique.tads) -b ../../../data/Bonev_2017_mES_tad/hTAD_boundaries.bed -u |wc -l
# 6309
intersectBed -a <(awk -v OFS="\t" '{print $1,$3-25000,$3+25000}' stable.unique.tads) -b ../../../data/Bonev_2017_mES_tad/hTAD_boundaries.bed -u |wc -l
# 6238


#D00 354
intersectBed -a <(awk -v OFS="\t" '{print $1,$2-25000,$2+25000}' D00.unique.tads) -b ../../../data/Bonev_2017_mES_tad/hTAD_boundaries.bed -u |wc -l
#96
intersectBed -a <(awk -v OFS="\t" '{print $1,$3-25000,$3+25000}' D00.unique.tads) -b ../../../data/Bonev_2017_mES_tad/hTAD_boundaries.bed -u |wc -l
#91

#D00 HERVH 34
intersectBed -a <(awk -v OFS="\t" '{print $1,$2,$2+50000}' D00.unique.tads.inc25k.bed) -b <(tail -n +2 ../../../data/annotation/hg19.HERVH-int.txt |cut -f 6-8) -c > o1 
intersectBed -a <(awk -v OFS="\t" '{print $1,$3-50000,$3}' D00.unique.tads.inc25k.bed) -b <(tail -n +2 ../../../data/annotation/hg19.HERVH-int.txt |cut -f 6-8) -c > o2 
intersectBed -a <(cat o1 o2 | awk -v OFS="\t"  '{if ( $4 > 0) { print $1,$2,$3 }}') -b ../../../data/Bonev_2017_mES_tad/hTAD_boundaries.bed -u |wc -l 
#6
