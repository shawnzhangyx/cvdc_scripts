### Methods adopted from https://github.com/SIWLab/Lab_Info/wiki/Ageing-LTR-insertions


file=multi_seq_aln/pairs/HERVH1.5P.bed
for file in multi_seq_aln/pairs/*.bed; do
echo $file
#bedtools getfasta -fi ~/annotations/hg19/hg19.fa -bed ${file} -name > ${file}.fa
#~/software/muscle3.8.31_i86linux64 -in ${file}.fa -out ${file}.afa
python ../../scripts/hervh/LTR_pairwise_differences.py -i ${file}.afa -o multi_seq_aln/LTR_Kdist.txt 

done

#find  multi_seq_aln/pairs/ -name '*.afa'|xargs -n 1 -P 10 python LTR_pairwise_differences.py -o multi_seq_aln/LTR_Kdist.txt -i 
