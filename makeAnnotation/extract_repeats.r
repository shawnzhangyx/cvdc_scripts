setwd("../../data/annotation/")
a=data.frame(fread("~/annotations/hg19/repeatmaster/RepeatMaster.hg19.txt"))
b=a
names = table(b$repName)
names = names(names[which(names>1000)])
names = sub("/","-",names)

for (name in names){
  print(name)
 out = b[which(b$repName == name),]
 write.table(out, paste0("repeats/",name,".txt"),row.names=F,col.names=F,quote=F,sep='\t')
}


