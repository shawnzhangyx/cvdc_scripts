dir=../../analysis/qualityControl/loop_vs_eQTL
cat ../../analysis/fithic/results/D00_HiC_Rep1/q0.01/*.significant.txt|grep -v "chr" - > ../../analysis/qualityControl/loop_vs_eQTL/D00_Rep1.fithic.loop
awk -v OFS="\t" -v bin=10000 '{print "chr"$1,$2,$2+bin,"chr"$3,$4,$4+bin,$5,$6,$7}' ../../analysis/qualityControl/loop_vs_eQTL/D00_Rep1.fithic.loop > ../../analysis/qualityControl/loop_vs_eQTL/D00_Rep1.fithic.f.loop.bed
awk -v OFS="\t" -v bin=10000 '{print "chr"$3,$4,$4+bin,"chr"$1,$2,$2+bin,$5,$6,$7}' ../../analysis/qualityControl/loop_vs_eQTL/D00_Rep1.fithic.loop > ../../analysis/qualityControl/loop_vs_eQTL/D00_Rep1.fithic.r.loop.bed
awk -v OFS="\t" -v FS="," '{if ( NR>1 ) print $2,$3,$4,$5,$23,$25 }' ../../data/eQTL/eQTL_table_leads01.csv > ../../analysis/qualityControl/loop_vs_eQTL/eQtl.bed
awk -v OFS='\t' '{if ( $5 > 10000 || $5 < -10000) print $1,$2,$3,$6 }' ../../analysis/qualityControl/loop_vs_eQTL/eQtl.bed > ../../analysis/qualityControl/loop_vs_eQTL/eQtl.gt10kb.bed
intersectBed -b $dir/D00_Rep1.fithic.f.loop.bed -a $dir/eQtl.gt10kb.bed -wb > $dir/eQtl.gt10kb.over.f.loop.txt
intersectBed -b $dir/D00_Rep1.fithic.r.loop.bed -a $dir/eQtl.gt10kb.bed -wb > $dir/eQtl.gt10kb.over.r.loop.txt

awk -v OFS='\t' '{print $8,$9,$10}' $dir/eQtl.gt10kb.over.f.loop.txt $dir/eQtl.gt10kb.over.r.loop.txt |sort |uniq -u > $dir/loop.anchor2.bed 
intersectBed -a $dir/loop.anchor2.bed -b ../../data/annotation/gencode.v19.annotation.transcripts.tss5k.bed -wao |awk -v OFS='\t' '{ print $1,$2,$3,$7}' - |sort|uniq -u > $dir/loop.anchor2.tss.txt


