for cluster in {1..5}; do
  awk -v OFS="\t" '{print $1,$2,$2+10000,$1,$3,$3+10000}' clusters/loops.${cluster}.order.bed > APA_plots/loops.${cluster}.order.for_juicer.txt
  done

for cluster in {1..5}; do
  (
  mkdir -p APA_plots/cluster${cluster}
  for day in D00 D02 D05 D07 D15 D80; do 
  java -jar /mnt/silencer2/home/yanxiazh/software/hic/juicebox/juicebox_tools.7.0.jar apa -k KR -r 10000 \
  ../../data/hic/juicer/${day}_HiC_Rep1.hic APA_plots/loops.${cluster}.order.for_juicer.txt APA_plots/cluster${cluster}/${day} 
  done
  ) &
  done

#for cluster in {1..5}; do 
#  montage APA_plots/cluster${cluster}/D??/10000/gw/APA.png -tile 6x1 APA_plots/cluster${cluster}.APA.png
#  done
  
