library(tidyverse)
a=read_delim("inter_chrom_int/hervh.pairs.rpkm_gt1.txt",delim="\t")
a = a[which(a$chr1 != a$chr2),]

chr_list = list()
for (chr1 in c(1:22)) { 
  chr_list[[chr1]] = list()  
  for (chr2 in c(chr1:22,"X")) {
  chr_list[[chr1]][[chr2]] = read_delim(paste0("inter_chrom_int/D00_HiC_Rep1/chr.",chr1,".",chr2,".10k.mat"),delim="\t",col_names=F)
    }
      
      }

### 
library(doParallel)
registerDoParallel(30)

out_dict = list()
for (i in 1:nrow(a)){
#out_dict = foreach(i=1:nrow(a)) %dopar% {
  print(i)
  x1 = as.numeric(a[i,2])
  x2 = as.numeric(a[i,5])
  chr1 = as.numeric(sub("chr","",a[i,1]))
  chr2 = sub("chr","",a[i,4])
#  if (chr2 != "X") { chr2 = as.numeric(chr2) }
  
  
  mat = chr_list[[ chr1 ]][[ chr2 ]] 
  tmp = mat %>%  filter( X1 < x1+50000 & X1 > x1-50000 & X2 < x2+50000  & X2 > x2-50000)
  tmp2 = tmp %>% mutate(X1I = floor(X1-x1)/1e4) %>% mutate(X2I = floor(X2-x2)/1e4) %>% mutate(Index=i)
#}



  if (nrow(tmp2)>0) { out_dict[[length(out_dict)+1]] = tmp2 } 
}


out = do.call(rbind, out_dict)
