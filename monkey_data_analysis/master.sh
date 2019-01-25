

## make HERVH tracks. 
cd ../../analysis/monkey_hervh/ 
grep HERVH-int ~/annotations/chimp/panTro6/repeatmasker/rmsk.txt |cut -f 6-8 |sort -k1,1 -k2,2n | mergeBed -d 1000 -i - | awk -v OFS="\t" '{print $0,$1":"$2"-"$3}' > panTro6.hervh.merged.bed
grep HERVH-int ~/annotations/marmoset/repeatmasker/rmsk.txt |cut -f 6-8 |sort -k1,1 -k2,2n | mergeBed -d 1000 -i - | awk -v OFS="\t" '{print $0,$1":"$2"-"$3}' > calJac3.hervh.merged.bed

awk -v OFS="\t" '{print $4,$1,$2,$3,$6}' panTro6.hervh.merged.bed > panTro6.hervh.merge.saf
awk -v OFS="\t" '{print $4,$1,$2,$3,$6}' calJac3.hervh.merged.bed > calJac3.hervh.merge.saf


mkdir rnaseq
chimp=../../data/rnaseq_pipe/panTro6/bam/*.bam
featureCounts -a panTro6.hervh.merge.saf -o rnaseq/panTro6.hervh.rnaseq.counts $chimp -F SAF -T 8

marmoset=../../data/rnaseq_pipe/calJac3/bam/*.bam
featureCounts -a calJac3.hervh.merge.saf -o rnaseq/calJac3.hervh.rnaseq.counts $marmoset -F SAF -T 8


