
# keep only promoters that overlap H3K4me3.
intersectBed -a ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -b ../chipseq/peaks/H3K4me3_D00/pooled/trurep_peaks.filtered.narrowPeak -u > gencode.v19.transcriopts.tss1k.overlap_D00_H3K4me3_peaks.bed 
