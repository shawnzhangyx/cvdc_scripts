pushd  ../../analysis/customLoops/
awk -v FS='\t' -v OFS='\t' '{print $2,$3,$4,$1,$5}' ../../data/gWAS/GWAS_Catolog_hg19.txt > gWAS/GWAS_Catolog_hg19.bed
intersectBed -a anchors/anchors.uniq.30k.bed -b gWAS/GWAS_Catolog_hg19.bed -wo > gWAS/gwas_overlaped.txt
mergeBed -i <(sort -k1,1 -k2,2n anchors/anchors.uniq.30k.bed) > gWAS/anchors.merged.bed

intersectBed -a gWAS/anchors.clusters2-5.bed -b gWAS/GWAS_Catolog_hg19.bed -wo > gWAS/gwas_overlaped.clusters2-5.txt
intersectBed -a gWAS/anchors.clusters3-5.bed -b gWAS/GWAS_Catolog_hg19.bed -wo > gWA/gwas_overlaped.clusters3-5.txt

mergeBed -i <(sort -k1,1 -k2,2n gWAS/anchors.clusters2-5.bed ) > gWAS/anchors.clusters2-5.merged.bed
mergeBed -i <(sort -k1,1 -k3,3n gWAS/anchors.clusters3-5.bed ) > gWAS/anchors.clusters3-5.merged.bed

