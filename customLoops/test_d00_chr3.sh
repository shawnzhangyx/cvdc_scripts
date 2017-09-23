cp /mnt/tscc/yanxiao/projects/cardiac_dev/analysis/customLoops/chr3.D00_HiC_Rep1.txt .
Rscript remove_pixel_wo_nearby.r chr3.D00_HiC_Rep1.txt
Rscript colapse_pixels.r chr3.D00_HiC_Rep1.txt.removed
awk -v OFS="\t" '{print "chr3",$1,$1+10000,"chr3",$2,$2+10000,$15}' <(tail -n +2 chr3.D00_HiC_Rep1.txt.removed.merged) |pgltools sort > chr3.D00_HiC_Rep1.txt.pgl

cp /mnt/tscc/yanxiao/projects/cardiac_dev/analysis/customLoops/chr3.D00_HiC_Rep2.txt .
Rscript remove_pixel_wo_nearby.r chr3.D00_HiC_Rep2.txt
Rscript colapse_pixels.r chr3.D00_HiC_Rep2.txt.removed
awk -v OFS="\t" '{print "chr3",$1,$1+10000,"chr3",$2,$2+10000,$15}' <(tail -n +2 chr3.D00_HiC_Rep2.txt.removed.merged) |pgltools sort> chr3.D00_HiC_Rep2.txt.pgl

pgltools intersect -a chr3.D00_HiC_Rep1.txt.pgl -b chr3.D00_HiC_Rep2.txt.pgl -d 20000 |wc -l

pgltools intersect -a chr3.D00_HiC_Rep1.txt.pgl -b chr3.D00_HiC_Rep2.txt.pgl -d 20000 -v |head


### HICCUPS 
grep chr3 /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/hic/loops/D00_HiC_Rep1.loop/merged_loops |pgltools sort > hiccups.D00.Rep1.txt
grep chr3 /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/hic/loops/D00_HiC_Rep2.loop/merged_loops |pgltools sort > hiccups.D00.Rep2.txt

pgltools intersect -a hiccups.D00.Rep1.txt -b hiccups.D00.Rep2.txt -d 20000 |wc -l


pgltools intersect -a chr3.D00_HiC_Rep1.txt.pgl -b hiccups.D00.Rep1.txt -d 20000 -v |sort -k7,7n |cut -f 1,2,5,7| head
pgltools intersect -b chr3.D00_HiC_Rep1.txt.pgl -a hiccups.D00.Rep1.txt -d 20000 -v |sort -k14,14n |cut -f 1,2,5,14

