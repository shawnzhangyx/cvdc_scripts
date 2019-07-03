bash preprocess.sh
Rscript mergeTable.r
### preprocess the distal-enhancer TSS loops
Rscript preprocessEnhancerDistalSNP.r
awk -v OFS="\t" '{ if ($2 > $3){print $1,$3,$2} else {print $0} }' ../../analysis/enhancer_promoter_interaction/enhancer2DistalValuesAndCorrelation/loops.txt |sort|uniq -u > ../../analysis/enhancer_promoter_interaction/enhancer2DistalValuesAndCorrelation/loops.sort.uniq.txt

rm ../../analysis/enhancer_promoter_interaction/enhancer2DistalValuesAndCorrelation/loops.mat.txt
for chr in {1..22..1} X
  do
  Rscript extractInteractions.r $chr &
  done

## extend loops
awk  '{ for (i = -1; i <= 1; i++)  {
        for (j = -1; j <= 1; j++)  {
            print $1, $2 + 10000*i, $3 + 10000*j
            }
            } }' ../../analysis/enhancer_promoter_interaction/enhancer2DistalValuesAndCorrelation/loops.txt |sort | uniq -u > ../../analysis/enhancer_promoter_interaction/enhancer2DistalValuesAndCorrelation/loops.extended.txt

Rscript analyzeEnhancerDistalSNP.r
