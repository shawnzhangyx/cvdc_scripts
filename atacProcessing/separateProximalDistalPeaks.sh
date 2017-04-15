intersectBed -a ../../data/atac/peaks/atac_merged_peaks.bed -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -u > ../../data/atac/peaks/atac_proximal_peaks.bed
intersectBed -a ../../data/atac/peaks/atac_merged_peaks.bed -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -v > ../../data/atac/peaks/atac_distal_peaks.bed

