cd ../../analysis/hervh
# merge herv internal sequences.
mergeBed -d 1000 -i <(cut -f 6-8 ../../data/annotation/hg19.HERVH-int.txt | sort -k1,1 -k2,2n) |awk -v OFS="\t" '{print $0,$1":"$2"-"$3}' > hervh.merged.bed
awk -v OFS="\t" '{print $1,$2-1000,$3+1000,$4}' hervh.merged.bed > hervh.ext1k.bed
awk '{printf "%s\t%1.0f\t%1.0f\t%s\n", $1,($2+$3)/2-500000,($2+$3)/2+500000,$4 } ' hervh.merged.bed | awk -v OFS="\t" '{ if ($2<0) { print $1,0,$3,$4 } else {print $0}}' > hervh.ext500k.bed

# merge LTR7 
mergeBed -d 1000 -i <(cut -f 6-8 ../../data/annotation/repeats/LTR7.txt | sort -k1,1 -k2,2n) |awk -v OFS="\t" '{print $0,$1":"$2"-"$3}' > LTR7.merged.bed


