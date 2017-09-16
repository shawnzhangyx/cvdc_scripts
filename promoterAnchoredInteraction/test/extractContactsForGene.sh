#MYH6
chr=14
pos=23870000
for name in $(cat ../../data/hic/meta/names.txt); do
  echo $name
  awk -v OFS="\t" -v name=$name -v pos=$pos '{if ($1==pos || $2==pos) print name,$0}' \
  ../../data/hic/matrix/$name/${chr}_10000.txt >> MYH6.contacts.txt
  done

