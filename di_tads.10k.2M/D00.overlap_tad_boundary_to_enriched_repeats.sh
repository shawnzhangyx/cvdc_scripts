#for repeats in $(ls ../../../data/annotation/repeats/*.txt); do
#  name=$(basename $repeats)
#  name=${name%.txt}
  #mkfifo o1 o2
  name=L1PA15-16
  name=L1P3
  name=MER67C
  intersectBed -a <(awk -v OFS="\t" '{print $1,$2-50000,$2+50000}' d00.txt) -b <(tail -n +2 ../../../data/annotation/repeats/${name}.txt |cut -f 6-8)  -u > $name.overlap.D00.TADs.txt
