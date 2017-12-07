mkfifo o1 o2

intersectBed -a <(awk -v OFS="\t" '{print $1,$2,$2+50000}' D00.unique.tads.inc25k.bed) -b <(tail -n +2 ../../../data/annotation/hg19.HERVH-int.txt |cut -f 6-8)  -u |wc -l #18

intersectBed -a <(awk -v OFS="\t" '{print $1,$3-50000,$3}' D00.unique.tads.inc25k.bed) -b <(tail -n +2 ../../../data/annotation/hg19.HERVH-int.txt |cut -f 6-8)  -u |wc -l #16

intersectBed -a <(awk -v OFS="\t" '{print $1,$2,$2+50000}' D00.unique.tads.inc25k.bed) -b <(tail -n +2 ../../../data/annotation/hg19.HERVH-int.txt |cut -f 6-8) -c > o1 |\
intersectBed -a <(awk -v OFS="\t" '{print $1,$3-50000,$3}' D00.unique.tads.inc25k.bed) -b <(tail -n +2 ../../../data/annotation/hg19.HERVH-int.txt |cut -f 6-8) -c > o2 |\
paste o1 o2 | awk '{if ($4>0 || $8>0) { n++} } END {print n}' #33


intersectBed -a <(awk -v OFS="\t" '{print $1,$2-25000,$2+25000}' D80.unique.tads ) -b <(tail -n +2 ../../../data/annotation/hg19.HERVH-int.txt |cut -f 6-8)  -u |wc -l #8

intersectBed -a <(awk -v OFS="\t" '{print $1,$3-25000,$3+25000}' D80.unique.tads ) -b <(tail -n +2 ../../../data/annotation/hg19.HERVH-int.txt |cut -f 6-8)  -u |wc -l #3


intersectBed -a <(awk -v OFS="\t" '{print $1,$2,$2+50000}' D00.unique.tads.inc25k.random_10x.bed ) -b <(tail -n +2 ../../../data/annotation/hg19.HERVH-int.txt |cut -f 6-8)  -u |wc -l #92
intersectBed -a <(awk -v OFS="\t" '{print $1,$3-50000,$3}' D00.unique.tads.inc25k.random_10x.bed ) -b <(tail -n +2 ../../../data/annotation/hg19.HERVH-int.txt |cut -f 6-8)  -u |wc -l #72


