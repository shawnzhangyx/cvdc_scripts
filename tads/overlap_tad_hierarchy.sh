intersectBed -a <(tail -n +2 combined_tads.uniq.gt1.txt|cut -f 1-3 ) -b <(tail -n +2 combined_tads.uniq.gt1.txt|cut -f 1-3) -wo -f 0.8 > tad_hierarchy/tads_to_tads_overlap.txt


