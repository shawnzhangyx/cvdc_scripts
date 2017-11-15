mergeBed -d 10000 -i <(cut -f 6-8 ../../data/annotation/hg19.HERVH-int.txt | sort -k1,1 -k2,2n) |awk -v OFS="\t" '{print $0,$1":"$2"-"$3}' > hervh.merged.bed
awk -v OFS="\t" '{print $1,$2-5000,$3+5000,$4}' hervh.merged.bed > hervh.ext5k.bed


