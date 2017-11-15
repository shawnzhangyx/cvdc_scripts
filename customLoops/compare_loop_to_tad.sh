tail -n +2 ../tads/combined_tads.uniq.gt1.txt|cut -f 1-6 |pgltools sort > loop_to_tad/tads.pgl
awk -v OFS='\t' '{ if(NR>1){print $1,$2-10000,$2+10000,$1,$3-10000,$3+10000 } }' ../tads/combined_tads.uniq.gt1.txt |pgltools sort > loop_to_tad/tad_corner.pgl

tail -n +2 combined_loops.uniq.gt1.juicer.txt |cut -f 1-6 |pgltools sort > loop_to_tad/loops.pgl 
pgltools intersect -a loop_to_tad/loops.pgl -b loop_to_tad/tad_corner.pgl -d 20000 -u > loop_to_tad/loop_over_tad_corner.pgl 
pgltools intersect -a loop_to_tad/loops.pgl -b loop_to_tad/tads.pgl -d 20000 -v > loop_to_tad/loop_inter_tad.pgl

