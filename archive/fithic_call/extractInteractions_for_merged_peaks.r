setwd("../../analysis/fithic/merged_peaks/")
chr = commandArgs(trailing=T)[1]

loops = data.frame(fread("rep_inter.all.txt"))
names = readLines("../../../data/hic/meta/names_v2.txt")

#inter.chr.list = list()
#for (chr in c(1:22,"X")){
  loop.chr = loops[which(loops$V1 ==paste0("chr",chr)),]
  loop.chr.ordered = loop.chr[,2:3]
#  loop.chr.ordered =t( apply(loop.chr[,2:3],1,function(vec){sort(vec)}))
  colnames(loop.chr.ordered) = c("x1","y1")
  inter.list = list()
  for (name in names){
    print(name)
    mat = data.frame(fread(paste0("../../../data/hic/matrix_raw/",name,'/',chr,'_10000.txt')))
    inter.list[[length(inter.list)+1]] = merge(loop.chr.ordered,mat,by.x=c("x1","y1"),by.y=c("V1","V2"),all.x=T)
    }
#  chr.table = do.call(cbind,inter.list)
#  chr.table = do.call(merge, list(by.x=c("x1","y1")),inter.list)
chr.table = Reduce(function(...) merge(...,by = c("x1","y1")),
       inter.list)
colnames(chr.table)[-c(1,2)] = paste0("D",rep(c("00","02","05","07","15","80"),each=2),rep(c("_1","_2"),6))

chr.table = cbind(rep(chr,nrow(chr.table)), chr.table)

  write.table(chr.table, "rep_inter.all.mat.txt",append=T,row.names=F,col.names=F,quote=F,sep='\t')
# inter.chr.list[[length(inter.chr.list)+1]] = chr.table[,c(1,2,seq(3,36,3))]
  

#  }
#  inter.table = 
