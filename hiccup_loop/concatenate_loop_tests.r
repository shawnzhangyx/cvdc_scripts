setwd("../../analysis/hiccup_loops")
files= list.files(pattern="requested_list_10000",path="loops",full.names=T,recursive=T)
names = sub("loops/(D.._HiC_Rep.)/requested_list_10000","\\1",files)

dat = list()
for (i in 1:12){
  dat[[i]] = data.frame(fread(files[[i]]))
  }

datm = Reduce(function(...)merge(...,by=c("chr1","x1","y1"),all.x=T,all.y=T),dat)

B = datm[,seq(17,ncol(datm),17)]
D = datm[,seq(18,ncol(datm),17)]
H = datm[,seq(19,ncol(datm),17)]
V = datm[,seq(20,ncol(datm),17)]

#Sig = ( B<0.05 | D <0.05 | H < 0.05 | V <0.05 )
Sig = ( B<0.1 | D <0.1 | H < 0.1 | V <0.1 )

#output = cbind(datm[,c(1,2,3)],datm[,seq(8,ncol(datm),17)],datm[,seq(17,ncol(datm),17)],datm[,seq(18,ncol(datm),17)])
out = cbind(datm[,c(1,2,3)],datm[,seq(8,ncol(datm),17)],Sig)
colnames(out) = c("chr","x1","y1",paste0("ob.",names),paste0("sig.",names))

write.table(out,"combined_loops.hiccup_refined.txt",row.names=F,quote=F,sep='\t')

