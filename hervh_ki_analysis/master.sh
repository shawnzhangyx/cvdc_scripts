# extract HERVH2 KI bam files. 
./find_valid_pairs.awk Bam_file chr13 56151346 56159088 hervh_ki1 

awk '{ if( $3=="chr13" && $4 > 56151346 && $4 < 56159088) {print $0 }}' ../../data/herv-ki/HERV-KI1/HERV-KI1.valid_pairs.dedup.sorted.txt > herv_ki1.interact.valid_pairs_1.txt &

awk '{ if( $7=="chr13" && $8 > 56151346 && $8 < 56159088) {print $0 }}' ../../data/herv-ki/HERV-KI1/HERV-KI1.valid_pairs.dedup.sorted.txt > herv_ki1.interact.valid_pairs_2.txt &


awk '{ if( $3=="chr13" && $4 > 56151346 && $4 < 56159088) {print $0 }}' ../../data/herv-ki/HERV-KI2/HERV-KI2.valid_pairs.dedup.sorted.txt > herv_ki2.interact.valid_pairs_1.txt &

awk '{ if( $7=="chr13" && $8 > 56151346 && $8 < 56159088) {print $0 }}' ../../data/herv-ki/HERV-KI2/HERV-KI2.valid_pairs.dedup.sorted.txt > herv_ki2.interact.valid_pairs_2.txt &


# KO profiles
awk '{ if( $3=="chr13" && $4 > 56151346 && $4 < 56159088) {print $0 }}' ../../data/herv-ko/hic/deep_run_pipe/HERV1/HERV1.valid_pairs.dedup.sorted.txt > herv_ko1.interact.valid_pairs_1.txt &

awk '{ if( $7=="chr13" && $8 > 56151346 && $8 < 56159088) {print $0 }}' ../../data/herv-ko/hic/deep_run_pipe/HERV1/HERV1.valid_pairs.dedup.sorted.txt > herv_ko1.interact.valid_pairs_2.txt &

awk '{ if( $3=="chr13" && $4 > 56151346 && $4 < 56159088) {print $0 }}' ../../data/herv-ko/hic/deep_run_pipe/HERV2/HERV2.valid_pairs.dedup.sorted.txt > herv_ko2.interact.valid_pairs_1.txt &

awk '{ if( $7=="chr13" && $8 > 56151346 && $8 < 56159088) {print $0 }}' ../../data/herv-ko/hic/deep_run_pipe/HERV2/HERV2.valid_pairs.dedup.sorted.txt > herv_ko2.interact.valid_pairs_2.txt & 

