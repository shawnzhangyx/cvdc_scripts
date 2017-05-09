loop=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/fithic/merged_peaks/rep_inter.all.txt
loopRev=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/fithic/merged_peaks/rep_inter.all.rev.txt
out=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/h3k27me3_loop/

awk '{ if ( $3-$2 >= 5000 ) print $0 }' /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq/merged_peaks/H3K27me3_merged_peaks.kept.bed > $out/h3k27me3_peaks.wide5k.bed
h3k27me3=$out/h3k27me3_peaks.wide5k.bed

# record the H3K27me3 that overlap with loops
intersectBed -a $h3k27me3 -b $loop -wo > $out/k27.loop.overlap.txt
intersectBed -a $h3k27me3 -b $loopRev -wo > $out/k27.loop.rev.overlap.txt


