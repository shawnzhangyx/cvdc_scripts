#!/bin/awk -f

BEGIN {
OFS="\t";
#chr="chr19";
#bin_size=1000000;
bin_num=int(chr_size/bin_size)+1;
a[bin_num,bin_num]=0;
#print chr, bin_size, chr_size, bin_num;
#print bin_num, bin_num,1,1;
}

{
  if ($3 != "nan"){
  a[int($1/bin_size),int($2/bin_size)] = $3;
  a[int($2/bin_size),int($1/bin_size)] = $3;
  }
  else {
  a[int($1/bin_size),int($2/bin_size)] = 0;
  a[int($2/bin_size),int($1/bin_size)] = 0;
  }

}
END {
  printf ""
#  for (j=0;j<500;j++){
  for (j=0;j<bin_num;j++){
    printf OFS "bin"6000000+j"|ce10|chr"chr":"1+j*bin_size"-"1+(j+1)*bin_size 
    }
  printf "\n"
#  for (i=0;i<500;i++){
  for (i=0;i<bin_num;i++){
    printf "bin"6000000+i"|ce10|chr"chr":"1+i*bin_size"-"1+(i+1)*bin_size

    for (j=0;j<bin_num;j++){
      idx = i SUBSEP j;
      printf OFS ((idx in a)?a[idx]:0) 
      }
      printf "\n"
      }
}



