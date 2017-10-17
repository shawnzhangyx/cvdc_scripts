input=$1
output=$2
echo input file: $input
echo output file: $output
awk -v OFS='\t' '{ print $4,$1,$2,$3,$6}' $1 > $2

