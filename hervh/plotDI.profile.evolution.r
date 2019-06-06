library(gridExtra)
setwd("../../analysis/hervh/evolution_analysis/")

#file = "Bonobo.DI.overlap.HERVH.txt"
#file = "Chimpanzee.DI.overlap.HERVH.txt"
files = c("D00_HiC_Rep1.DI.overlap.HERVH.txt","Bonobo.DI.overlap.HERVH.txt","Chimp.DI.overlap.HERVH.txt","Marmoset.DI.overlap.HERVH.txt","Mouse.DI.overlap.HERVH.txt")


glist = list()
for (file in files){
a=read.table(file,stringsAsFactors=F)
a=a[a$V4 %in% paste0("HERVH",1:50),]
a$pos = floor( (a$V6-(a$V2+a$V3)/2 )/10000)
agg = aggregate(V8~pos,a,median)
glist[[file]] = agg
}


gglist = list()
idx=1
gglist[[idx]] = ggplot(subset(glist[[idx]],abs(pos)<=20)) + geom_col(aes(x=pos,y=V8,fill=V8>0)) + 
    scale_fill_manual(values=cbbPalette[c(6,7)]) + theme_bw()

for (idx in 2:length(files)) {
  gglist[[idx]] = ggplot(subset(glist[[idx]],abs(pos)<=20)) + geom_col(aes(x=pos,y=V8,fill=V8>0)) + ylim(-5,10)+
    scale_fill_manual(values=cbbPalette[c(6,7)]) + theme_bw()
}


pdf("DI_profile.evolution.pdf",height=8,width=5)
grid.arrange(grobs=gglist,ncol=1)
dev.off()

