pushd ../../data/hic/meta/
name=D00_HiC_Rep1
for name in $(cat names.txt); do
cat ../matrix_raw/$name/*.txt |awk -v name=$name 'BEING{a=0} {a+=$3}END{print name,a}' >> total_cis_pair.txt &
done


