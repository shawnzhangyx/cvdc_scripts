#fastaFromBed -fi ~/annotations/hg19/hg19.fa -bed <(

findMotifsGenome.pl <(cut -f 6-8 ../../data/annotation/hg19.HERVH-int.txt) hg19 hervh_homer_motif -size given


findMotifsGenome.pl multi_seq_aln/dyn.LTR7.bed hg19 dyn_LTR7_homer_motif -bg multi_seq_aln/nondyn.LTR7.bed -size given

findMotifsGenome.pl multi_seq_aln/all.LTR7.bed hg19 all_LTR7.homer.motif -size given

