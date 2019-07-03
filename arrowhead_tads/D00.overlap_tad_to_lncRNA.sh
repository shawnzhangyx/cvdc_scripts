intersectBed -a D00.unique.tads.inc25k.bed -b <(tail -n +2 ../../../data/rnaseq/lncRNA/lncRNA.D00.high.edgeR.bed)  -u |wc -l #73
intersectBed -a D00.unique.tads.inc25k.random_10x.bed -b <(tail -n +2 ../../../data/rnaseq/lncRNA/lncRNA.D00.high.edgeR.bed)  -u |wc -l #517

intersectBed -a D00.unique.tads.inc25k.bed -b <(tail -n +2 ../../../data/annotation/hg19.HERVH-int.txt |cut -f 6-8)  -u |wc -l #84
intersectBed -a D00.unique.tads.inc25k.random_10x.bed -b <(tail -n +2 ../../../data/annotation/hg19.HERVH-int.txt |cut -f 6-8)  -u |wc -l #422

