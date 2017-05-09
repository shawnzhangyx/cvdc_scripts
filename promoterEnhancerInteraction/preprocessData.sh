# overlap the TSS with the first anchor of loops. 
tss=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/annotation/gencode.v19.annotation.transcripts.tss5k.bed
loop=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/fithic/merged_peaks/rep_inter.all.txt
loopRev=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/fithic/merged_peaks/rep_inter.all.rev.txt
out=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/enhancer_promoter_interaction

# record the TSSs that overlap with loops
intersectBed -a $tss -b $loop -wo > $out/tss.loop.overlap.txt
intersectBed -a $tss -b $loopRev -wo >> $out/tss.loop.overlap.txt

#record the loops that overlap with TSS. 
intersectBed -a $loop -b $tss -u > $out/loop.inter.tss.txt
intersectBed -a $loopRev -b $tss -u >> $out/loop.inter.tss.txt

enhancerDistal=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/peaks/atac_distal_peaks.bed
# intersect TSS-loops with ATAC-seq distal peaks. 
awk -v OFS='\t' '{print $4,$5,$6,$1,$2,$3}' $out/loop.inter.tss.txt | intersectBed -a stdin -b $enhancerDistal -u > $out/loop.inter.enhancerDistal.tss.txt 
awk -v OFS='\t' '{print $4,$5,$6,$1,$2,$3}' $out/loop.inter.tss.txt | intersectBed -a $enhancerDistal -b stdin -wo > $out/enhancerDistal.loop.overlap.txt

# intersect TSS-loops with ATAC-seq distal peaks that overlap with motif. 
enhancerDistalSNP=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/peaks/atac_distal_peaks.overlap_SNP.bed
awk -v OFS='\t' '{print $4,$5,$6,$1,$2,$3}' $out/loop.inter.tss.txt | intersectBed -a $enhancerDistalSNP -b stdin -wo > $out/enhancerDistalSNP.loop.overlap.txt

