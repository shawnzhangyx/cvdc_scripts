intersectBed -a <(cut -f 6-8 ../../data/annotation/repeats/LTR7.txt ) -b <( bedtools shift -i hervh.dynamicBoundaries.for_deeptools.bed -g ~/annotations/hg19/hg19.chrom.sizes -p -500 -m 500 ) > multi_seq_aln/dyn.LTR7.bed
intersectBed -a <(cut -f 6-8 ../../data/annotation/repeats/LTR7.txt ) -b <( bedtools shift -i hervh.sorted_rnaseq.strand.bed -g ~/annotations/hg19/hg19.chrom.sizes -p -500 -m 500 ) > multi_seq_aln/all.LTR7.bed
intersectBed -a multi_seq_aln/all.LTR7.bed -b multi_seq_aln/dyn.LTR7.bed -v > multi_seq_aln/nondyn.LTR7.bed

fastaFromBed -fi /projects/ps-renlab/share/bwa_indices/hg19.fa -bed multi_seq_aln/dyn.LTR7.bed > multi_seq_aln/dyn.LTR7.fasta
fastaFromBed -fi /projects/ps-renlab/share/bwa_indices/hg19.fa -bed <(cut -f 6-8 ../../data/annotation/repeats/LTR7.txt ) > multi_seq_aln/LTR7.fasta


intersectBed -a <( bedtools shift -i hervh.sorted_rnaseq.strand.bed -g ~/annotations/hg19/hg19.chrom.sizes -p -500 -m 500 ) -b <(grep -P "LTR7[^0-9]" ~/annotations/hg19/repeatmaster/RepeatMaster.hg19.txt |cut -f 6-8,11) -wo  > multi_seq_aln/5p_LTRs.txt 

intersectBed -a <( bedtools shift -i hervh.sorted_rnaseq.strand.bed -g ~/annotations/hg19/hg19.chrom.sizes -p 500 -m -500 ) -b <(grep -P "LTR7[^0-9]" ~/annotations/hg19/repeatmaster/RepeatMaster.hg19.txt |cut -f 6-8,11) -wo  > multi_seq_aln/3p_LTRs.txt

