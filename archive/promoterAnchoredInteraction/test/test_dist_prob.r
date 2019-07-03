######
a=read.table("D00_HiC_Rep1/1.dist.total")
b=read.table("D00_HiC_Rep1/all.dist.total")

a$prob = a$V2/a$V3
b$prob = b$V2/b$V3



### comparing between samples. 

names = readLines("../../data/hic/meta/names.txt")

glist = list()
for (name in names){
glist[[name]] = read.delim(paste0(name,"/all.dist.total"),header=F)
glist[[name]]$name=name

}
out = do.call(rbind,glist)

out$mean=out$V2/out$V3

ggplot(out,aes(x=V1,y=mean,color=name)) + geom_point() + 
  scale_x_log10() + scale_y_log10()



