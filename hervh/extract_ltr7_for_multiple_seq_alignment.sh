intersectBed -a <(cut -f 6-8 ../../data/annotation/repeats/LTR7.txt ) -b <( bedtools shift -i hervh.dynamicBoundaries.for_deeptools.bed -g ~/annotations/hg19/hg19.chrom.sizes -p -500 -m 500 ) > multi_seq_aln/dyn.LTR7.bed
intersectBed -a <(cut -f 6-8 ../../data/annotation/repeats/LTR7.txt ) -b <( bedtools shift -i hervh.sorted_rnaseq.strand.bed -g ~/annotations/hg19/hg19.chrom.sizes -p -500 -m 500 ) > multi_seq_aln/all.LTR7.bed
intersectBed -a multi_seq_aln/all.LTR7.bed -b multi_seq_aln/dyn.LTR7.bed -v > multi_seq_aln/nondyn.LTR7.bed

fastaFromBed -fi /projects/ps-renlab/share/bwa_indices/hg19.fa -bed multi_seq_aln/dyn.LTR7.bed > multi_seq_aln/dyn.LTR7.fasta
fastaFromBed -fi /projects/ps-renlab/share/bwa_indices/hg19.fa -bed <(cut -f 6-8 ../../data/annotation/repeats/LTR7.txt ) > multi_seq_aln/LTR7.fasta
