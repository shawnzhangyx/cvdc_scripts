pushd ../../analysis/gWAS_customLoop/
intersectBed -b ../../data/gWAS/gWAS.overlap_atac_distal.uniq.txt -a ../customLoops/anchors/anchors.uniq.30k.bed -wo > anchors.overlap_ATAC_GWAS.bed

