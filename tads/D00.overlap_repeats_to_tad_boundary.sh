cd  ../../analysis/tads/stage_specific_tads/
mkdir repeats/
for name in $(cat "D00.enriched_repeats.txt"); do
  echo $name
  intersectBed -b <(awk -v OFS="\t" '{print $1,$2,$2+50000}' D00.unique.tads.inc25k.bed) -a <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u > repeats/$name.bed 
  intersectBed -b <(awk -v OFS="\t" '{print $1,$3-50000,$3}' D00.unique.tads.inc25k.bed) -a <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u >> repeats/$name.bed
  done 
for name in $(cat "D00.enriched_repeats.txt"); do
  mergeBed -d 2000 -i <(sort -k1,1 -k2,2n repeats/$name.bed) > repeats/$name.merged.bed
  done


base=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/trackhub/hg19
for name in $(cat "D00.enriched_repeats.txt"); do
  echo $name
  for mark in H3K27ac H3K4me1 H3K4me3 rnaseq; do 
  echo $mark
  computeMatrix reference-point -S \
              $base/${mark}_D00.rpkm.bw  \
              $base/${mark}_D02.rpkm.bw  \
              $base/${mark}_D05.rpkm.bw  \
              $base/${mark}_D07.rpkm.bw  \
              $base/${mark}_D15.rpkm.bw  \
              $base/${mark}_D80.rpkm.bw  \
                  -R repeats/$name.merged.bed \
                  --beforeRegionStartLength 50000 \
                  --afterRegionStartLength 50000 \
                  --skipZeros -o repeats/$name.${mark}.gz

  plotProfile -m repeats/$name.${mark}.gz \
              -out repeats/$name.${mark}.pdf \
              --numPlotsPerRow 2 \
              --perGroup \
              --colors "#2166ac" "#67a9cf" "#d1e5f0" "#fddbc7" "#ef8a62" "#b2182b" \
              --plotTitle "$name profile" 
    done
  done

mark=rnaseq
computeMatrix reference-point -S \
              $base/${mark}_D00.rpkm.bw  \
              $base/${mark}_D02.rpkm.bw  \
              $base/${mark}_D05.rpkm.bw  \
              $base/${mark}_D07.rpkm.bw  \
              $base/${mark}_D15.rpkm.bw  \
              $base/${mark}_D80.rpkm.bw  \
              -R repeats/HERVH-int.merged.bed repeats/L1PA13.merged.bed repeats/L1P3.merged.bed repeats/L1PA15-16.merged.bed repeats/MLT2A2.merged.bed repeats/MER67C.merged.bed repeats/MER67D.merged.bed \
              --beforeRegionStartLength 50000 \
              --afterRegionStartLength 50000 \
              --skipZeros -o repeats/All.${mark}.gz

  plotProfile -m repeats/All.${mark}.gz \
              -out repeats/All.${mark}.pdf \
              --numPlotsPerRow 2 \
              --perGroup \
              --colors "#2166ac" "#67a9cf" "#d1e5f0" "#fddbc7" "#ef8a62" "#b2182b" \
              --plotTitle "$name profile"



