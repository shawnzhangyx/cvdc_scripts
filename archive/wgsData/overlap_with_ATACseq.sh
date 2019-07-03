pushd ../../data/wgsData/
intersectBed -a ../atac/peaks/atac_merged_peaks.bed -b wgs_denovo_case.bed -wo > wgs_denovo_case.overlap_atac.txt
intersectBed -a ../atac/peaks/atac_distal_peaks.bed -b wgs_denovo_case.bed -wo > wgs_denovo_case.overlap_atac_distal.txt
popd
