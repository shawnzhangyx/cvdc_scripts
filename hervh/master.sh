mkdir ../../analysis/hervh
cd ../../analysis/hervh

bash merge_hervh_seq.sh

## calculate closeist distance to TAD boundaries. 
bedtools closest -a <(sort -k1,1 -k2,2n hervh.sorted_rnaseq.bed) -b ../tads/tad_boundary/D00.boundary.bed -d > hervh.dist.tad_boundary.txt

