pushd ../../data/annotation
python ~/software/github/seq-min-scripts/generate_fixed_size_genome_segments.py hg19.chrom.sizes hg19.2k.tiling.bed 2000
awk -v OFS='\t' '{print "region"NR,$0,""}' hg19.2k.tiling.bed > hg19.2k.tiling.saf
popd
