cd ../../analysis/tads/
for name in $(cat ../../data/hic/meta/names.txt);do
echo $name

sample=../../data/hic/juicer/${name}.hic
> oe/$name.oe.txt
tail -n +2  combined_tads.uniq.txt |
while read chr1 x1 x2 field4; do
  java -jar ~/software/hic/juicebox/juicebox_tools.7.0.jar dump oe KR $sample chr$chr1:$x1:$x2 chr$chr1:$x1:$x2 BP 10000 oe/$name.tmp &&
  awk -v chr=$chr1 -v x1=$x1 -v x2=$x2 -v OFS="\t" '{print chr,x1,x2,$0}' oe/$name.tmp >> oe/$name.oe.txt
done

done
