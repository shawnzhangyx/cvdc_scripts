pushd ../../analysis/compareVISTA/
intersectBed -a ../customLoops/anchors/anchors.uniq.30k.bed -b ~/annotations/vista_database/VISTA_02_20_2018.hs_mm_combined.hg19.bed  -wo > anchor.vista.ovleraps.txt

intersectBed -a ../customLoops/anchors/anchors.uniq.30k.bed -b ~/annotations/vista_database/vista.hg19.bed  -wo > anchor.vista_hs.ovleraps.txt

# generate 30k bins 
# python ~/software/github/seq-min-scripts/generate_fixed_size_genome_segments.py ~/annotations/hg19/hg19.chrom.sizes hg19_30k_tiling_bin.bed 30000
#intersectBed -a hg19_30k_tiling_bin.bed -b ~/annotations/vista_database/VISTA_02_20_2018.hs_mm_combined.hg19.bed -wo > random30k.vista.ovleraps.txt
