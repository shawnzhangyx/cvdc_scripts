pushd ../../analysis/atacCenteredSites/

cat ../../data/tfChIPseq/peaks/GATA4_D*/*.narrowPeak > overlap_GATA4/GATA4.all_peaks.bed
intersectBed -a ../../data/atac/peaks/atac_merged_peaks.summit.2k.txt -b overlap_GATA4/GATA4.all_peaks.bed -f 0.5 -F 0.5 -e -u > overlap_GATA4/ATAC_summit.2k.overlap_GATA4.bed
intersectBed -a overlap_GATA4/ATAC_summit.2k.overlap_GATA4.bed -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -v > overlap_GATA4/ATAC_summit.2k.overlap_GATA4.distal.bed
