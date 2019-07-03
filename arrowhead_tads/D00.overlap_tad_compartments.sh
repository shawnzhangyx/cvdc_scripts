pushd ../../analysis/tads/stage_specific_tads/

intersectBed -a <(tail -n +2 ../../ab_compartments/pc1_data/D00_1_SP98_pcaOut.PC1.bedGraph ) -b D00.unique.tads -u | awk '{ if ($4>= 0){pos++} else {neg++}} END {print pos,neg }'
## 387 1776

intersectBed -a <(tail -n +2 ../../ab_compartments/pc1_data/D02_1_SP100_pcaOut.PC1.bedGraph ) -b D00.unique.tads -u | awk '{ if ($4>= 0){pos++} else {neg++}} END {print pos,neg }'
## 340 1824
intersectBed -a <(tail -n +2 ../../ab_compartments/pc1_data/D80_1_SP108_pcaOut.PC1.bedGraph ) -b D00.unique.tads -u | awk '{ if ($4>= 0){pos++} else {neg++}} END {print pos,neg }'
## 251 1912

intersectBed -a <(tail -n +2 ../../ab_compartments/pc1_data/D00_1_SP98_pcaOut.PC1.bedGraph ) -b D80.unique.tads -u | awk '{ if ($4>= 0){pos++} else {neg++}} END {print pos,neg }'
# 747 1280
intersectBed -a <(tail -n +2 ../../ab_compartments/pc1_data/D80_1_SP108_pcaOut.PC1.bedGraph ) -b D80.unique.tads -u | awk '{ if ($4>= 0){pos++} else {neg++}} END {print pos,neg }'
# 701 1326

intersectBed -a <(tail -n +2 ../../ab_compartments/pc1_data/D00_1_SP98_pcaOut.PC1.bedGraph ) -b gain.unique.tads -u | awk '{ if ($4>= 0){pos++} else {neg++}} END {print pos,neg }'
# 216 353
intersectBed -a <(tail -n +2 ../../ab_compartments/pc1_data/D00_1_SP98_pcaOut.PC1.bedGraph ) -b <(tail -n +2 ../combined_tads.uniq.gt1.txt) -u | awk '{ if ($4>= 0){pos++} else {neg++}} END {print pos,neg }'
# 24461 26221

tail -n +2 ../../ab_compartments/pc1_data/D00_1_SP98_pcaOut.PC1.bedGraph | awk '{ if ($4>= 0){pos++} else {neg++}} END {print pos,neg }'
# 26840 29187


