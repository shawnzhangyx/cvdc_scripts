#!/usr/bin/env python
import gzip
import os

os.chdir("../../data/gWAS")

snp_list = list()
with open("GWAS_Catolog_all_09282017.red.tsv") as f1:
#with open("test") as f1:
  for line in f1:
    snp_list.append(line.strip().split('\t')[0])
  print(len(snp_list))

snp_list = list(set(snp_list))
print(snp_list)
print(len(snp_list))


snp_info_list = list()
with gzip.open("../annotation/all.snps.gz",'r') as f2:
  for line in f2:
    snp = line.strip().split()[3]
    if snp.decode() in snp_list:
      print(len(snp_list))
      snp_list.remove(snp.decode())
      snp_info_list.append(line)
      if (len(snp_list)==0):
        break
#    else:
#      print(snp)

with open("SNP_info.txt",'w') as f3:
  for line in snp_info_list:
    f3.write(line.decode()+'\n')
