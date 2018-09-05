### Methods adopted from https://github.com/SIWLab/Lab_Info/wiki/Ageing-LTR-insertions


file=multi_seq_aln/pairs/HERVH1.5P.bed
for file in multi_seq_aln/pairs/*.bed; do
echo $file
#bedtools getfasta -fi ~/annotations/hg19/hg19.fa -bed ${file} -name > ${file}.fa
#~/software/muscle3.8.31_i86linux64 -in ${file}.fa -out ${file}.afa
python ../../scripts/hervh/LTR_pairwise_differences.py -i ${file}.afa -o multi_seq_aln/LTR_Kdist.txt 

done

#find  multi_seq_aln/pairs/ -name '*.afa'|xargs -n 1 -P 10 python LTR_pairwise_differences.py -o multi_seq_aln/LTR_Kdist.txt -i 



for file1 in multi_seq_aln/HERVH_int_human_chimp/HERVH*.Chimp.bed; do 
  file2=${file1/Chimp/Human}
  file3=${file1/Chimp.bed/.fa}
  bedtools getfasta -fi ~/annotations/chimp/panTro5.fa -bed ${file1} -name > ${file3}
  bedtools getfasta -fi ~/annotations/hg19/hg19.fa -bed ${file2} -name >> ${file3}
  ~/software/muscle3.8.31_i86linux64 -in ${file3} -out ${file3}.afa
  python ../../scripts/hervh/LTR_pairwise_differences.py -i ${file3}.afa -o multi_seq_aln/HERVH_int_Kdist.txt
  done

for file1 in multi_seq_aln/LTR_5P_human_chimp/HERVH*.Chimp.bed; do
  file2=${file1/Chimp/Human}
  file3=${file1/Chimp.bed/.fa}
  bedtools getfasta -fi ~/annotations/chimp/panTro5.fa -bed ${file1} -name > ${file3}
  bedtools getfasta -fi ~/annotations/hg19/hg19.fa -bed ${file2} -name >> ${file3}
  ~/software/muscle3.8.31_i86linux64 -in ${file3} -out ${file3}.afa
  python ../../scripts/hervh/LTR_pairwise_differences.py -i ${file3}.afa -o multi_seq_aln/LTR5P.HvsC.Kdist.txt
  done

