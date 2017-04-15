#if [ ! -d ../../analysis/fithic/ ]; then mkdir ../../analysis/fithic/; fi 
#if [ ! -d ../../analysis/fithic/preprocessed_data ]; then mkdir ../../analysis/fithic/preprocessed_data; fi
#chr=14
#for name in $(cat ../../data/hic/meta/names.txt)
#  do 
#  (
#  dir=../../analysis/fithic/preprocessed_data/$name 
#  if [ ! -d $dir ]; then mkdir $dir; fi 
#  output_contact="../../analysis/fithic/preprocessed_data/$name/${chr}_10000.contact.txt"
#  output_bias="../../analysis/fithic/preprocessed_data/$name/${chr}_10000.bias.txt"
#  output_frag="../../analysis/fithic/preprocessed_data/$name/${chr}_10000.frag.txt"
#  awk -vOFS="\\t" -v chr=14 '{{print chr,$1,chr,$2,int($3)}}' ../../data/hic/matrix_raw/$name/${chr}_10000.txt > $output_contact
#  awk -vOFS="\\t" -v chr=14 -v bin=10000 '$1=="NaN"{{$1="1.0"}}{{print chr,NR*bin,$1}}' ../../data/hic/juicerBias/$name/${chr}_10000.txt > $output_bias
#  python $HOME/software/github/hic-kit/convert_juicer_format_for_fithic.py -i $output_contact -b $output_bias -o $output_frag
#  gzip $output_contact
#  gzip $output_bias
#  gzip $output_frag
#  ) &
#  done
#
#wait
#echo done


#chr=14
for chr in {1..22..1} X 
  do 
for name in $(cat ../../data/hic/meta/names.txt)
  do
  (
  dir=../../analysis/fithic/preprocessed_data/$name
  if [ ! -d $dir ]; then mkdir $dir; fi
  output_contact_norm="../../analysis/fithic/preprocessed_data/$name/${chr}_10000.contact.norm.txt"
  output_bias="../../analysis/fithic/preprocessed_data/$name/${chr}_10000.bias.txt"
  output_frag_norm="../../analysis/fithic/preprocessed_data/$name/${chr}_10000.frag.norm.txt"
  awk -vOFS="\\t" -v chr=$chr '{{print chr,$1,chr,$2,int($3)}}' ../../data/hic/matrix/$name/${chr}_10000.txt > $output_contact_norm
  awk -vOFS="\\t" -v chr=$chr -v bin=10000 '$1=="NaN"{{$1="1.0"}}{{print chr,NR*bin,$1}}' ../../data/hic/juicerBias/$name/${chr}_10000.txt > $output_bias

  python $HOME/software/github/hic-kit/convert_juicer_format_for_fithic.py -i $output_contact_norm -b $output_bias -o $output_frag_norm
  gzip -f $output_contact_norm 
  gzip -f $output_bias
  gzip -f $output_frag_norm
  ) &
  done

wait
echo done
  done


