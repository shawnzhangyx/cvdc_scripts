library(data.table)
setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/hic/dixonMatrix")
files = list.files(pattern="txt")

int.list = list()
for (file in files){
  line = colSums(data.frame(fread(file,nrows=3,skip=2386)))
  int.list[[file]] = line
}
int = do.call(rbind,int.list)
int = sweep(int,1,rowSums(int)/10000,'/')
int.slice  = int[,2350:2420]
melted = melt(data.frame(rownames(int),int.slice))

#melted = melt(data.frame(rownames(int),int))

#ggplot(melted) + geom_tile(aes(x=variable,y=rownames.int.,fill=value)) + 
#scale_fill_gradient(low="white",high="red")
pdf("myh6_myh7.pdf",height=10,width=20)
ggplot(melted)+ geom_line(aes(x=variable,y=value,group=rownames.int.,col=rownames.int.))+
scale_color_hue(h=c(0,180)) +
theme( axis.text.x = element_text(angle=90))
dev.off()


