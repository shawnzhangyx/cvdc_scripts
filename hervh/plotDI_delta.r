a=read.csv("herv.rnaseq_sorted.DI_delta.csv")
a$X=NULL
a$name = factor(a$name,levels=a$name)

pdf("figures/herv.rnaseq_sorted.DI_delta.pdf")
melted = melt(a)
ggplot(melted) + geom_tile(aes(x=variable,y=name,
                                fill=ifelse(value>0, log2(value),-log2(-value)) )) +
  scale_fill_gradient2(high="red",low="blue") + 
  theme(axis.text.y=element_blank(),
        axis.text.x=element_text(angle=90)
  )
  dev.off()

deltas = as.numeric(unlist(a[,2:13]))
#CUTOFF = quantile(deltas,0.85)
CUTOFF = 50


b=a
b[,2:13] = b[,2:13]>CUTOFF
#b$ES = rowSums(b[,2:3])==2 & rowSums(b[,4:13])<=2 
b$ES = rowSums(b[,2:3])>=1 & apply(a[,4:7],1,median)/(a$D00_HiC_Rep1+a$D00_HiC_Rep2) < 1/4 

melted = melt(b,id.vars="name")
pdf("figures/herv.rnaseq_sorted.boundaries.pdf")
ggplot(melted) + geom_tile(aes(x=variable,y=name,fill=value)) + 
  theme(axis.text.y=element_blank(),
        axis.text.x=element_text(angle=90)
            )
dev.off()


dIndex =  which(b$ES==TRUE)
dIndex = dIndex[which(dIndex<100)]

write.table(a[dIndex,],"hervh.dynamicBoundaries.txt",row.names=F,col.names=F,quote=F,sep='\t')
write.table(a[-dIndex,],"hervh.nonDynamicBoundaries.txt",row.names=F,col.names=F,quote=F,sep='\t')

