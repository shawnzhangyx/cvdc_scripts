#fastaFromBed -fi ~/annotations/hg19/hg19.fa -bed <(

findMotifsGenome.pl <(cut -f 6-8 ../../data/annotation/hg19.HERVH-int.txt) hg19 hervh_homer_motif -size given

