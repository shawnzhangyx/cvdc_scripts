cd ../../analysis/insulation_tads/
for sample in $(cat ../../data/hic/meta/names.txt); do
intersectBed -a <(tail -n +2 combined_tads.uniq.gt1.txt|cut -f 1-3) -b ../../data/hic/insulation/${sample}.ins.is500001.ids200001.bedGraph -wo > insulation_score/${sample}.ins.txt
done
