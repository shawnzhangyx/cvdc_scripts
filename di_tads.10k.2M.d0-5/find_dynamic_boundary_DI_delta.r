setwd("../../analysis/di_tads.10k.2M.d0-5")

CUTOFF = 200
a=read.csv(paste0("boundaries/combined_boundary.DI_cutoff.",CUTOFF,".csv"))

a$D00 = a[,5] >CUTOFF | a[,6] > CUTOFF 
a$D02 = a[,7] >CUTOFF | a[,8] > CUTOFF
a$D05 = a[,9] >CUTOFF | a[,10] > CUTOFF

colSums(a[,11:13])
a$num_gtCT = rowSums(a[,11:13])
table(a$num_gtCT)

dyn = a[which(a$num_gtCT <3),]

a$D00 = a[,5] >CUTOFF & a[,6] > CUTOFF
a$D02 = a[,7] >CUTOFF & a[,8] > CUTOFF
a$D05 = a[,9] >CUTOFF & a[,10] > CUTOFF
colSums(a[,11:13])
a$num_gtCT = rowSums(a[,11:13])
table(a$num_gtCT)

## plot the TAD calls. 
calls = a[,11:13]
calls = calls[order(calls$D00,calls$D02,calls$D05),]
rownames(calls) = 1:nrow(calls)
melted = melt(as.matrix(calls))
#ggplot(melted) + geom_tile(aes(x=Var2,y=Var1,fill=value))

out = a[,5:10]
rownames(out)  =paste0(a$chr1,":",a$x1)
#out = a[which(a$num_gtCT<6),5:16]
#rownames(out) = paste0(a$chr1[which(a$num_gtCT<6)],":",a$x1[which(a$num_gtCT<6)])

out[out>500] = 500
out[out< 0] = 0

#melted = melt(as.matrix(out))
#ggplot(melted) + geom_tile(aes(x=Var2,y=Var1,fill=value)) 

library(limma)
b = log2(out+20)

group = factor(substr(colnames(b),7,9))
design = model.matrix(~0+group)
colnames(design) = levels(group)

fit = lmFit(b, design)

myContrasts = c("D02-D00") #,"D05-D02","D05-D00")
contrast.matrix = eval(as.call(c(as.symbol("makeContrasts"),as.list(myContrasts),levels=list(design))))

fit2 = contrasts.fit(fit, contrast.matrix)
fit4 = eBayes(fit2,trend=F)
##
fdr = apply(fit4$p.value,2,p.adjust,method="BH")

#apply(fdr<0.05,2,table)

dyn.name = rownames(b)[which(rowSums(fdr<0.05)>0)]

dyn.out = a[which(paste0(a$chr1,":",a$x1) %in% dyn.name),]
dyn.out = dyn.out[which(dyn.out$num_gtCT %in% 1:2),]
dim(dyn.out)
### plot the TAD calls
calls = dyn.out[,11:13]

mat = dyn.out[,5:10]
mat[mat>500] = 500
mat[mat< 0] = 0
#hc = hclust(as.dist(1- cor(t(mat))))
#mat = mat[hc$order,]
mat = mat[order(calls$D00,calls$D02,calls$D05),]

cor2 = cor(mat)
hc2 = hclust(as.dist(1-cor2),method="average")
hc2$order = 1:6
pdf("tad_bd.DI_delta.sample_hc.pdf")#,height=3,width=4)
plot(hc2)
dev.off()

rownames(mat) =1:nrow(mat)
melted = melt(as.matrix(mat))
pdf("tad_bd.DI_delta.pdf",height=5,width=4)
ggplot(melted) + geom_tile(aes(x=Var2,y=Var1,fill=value)) + 
  scale_fill_gradientn(colors=c("#2c7fb8","white","#de2d26","#de2d26"),
    values=c(0,0.4,0.8,1))+
    scale_x_discrete(labels=sub("delta.(.*)_HiC_Rep(.)","\\1.R\\2",colnames(mat)))+
    xlab("") + ylab("") +
    theme(
    #legend.justification = c("right", "top")
    axis.text.y = element_blank(),
    axis.text.x = element_text(angle=90,size=12,face="bold",vjust=0.5),
    legend.position="top",
    panel.background = element_rect(fill = NA, colour = "black"),
    panel.grid = element_blank()
    )
dev.off()


calls.o = calls[order(calls$D00,calls$D02,calls$D05),]
rownames(calls.o) = 1:nrow(calls.o)
melted = melt(as.matrix(calls.o))
pdf("tad_bd.calls.pdf",height=5,width=4)
ggplot(melted) + geom_tile(aes(x=Var2,y=Var1,fill=value))
dev.off()


dyn.out$type ="other_dynamic"
dyn.out$type[which(dyn.out$D00 & dyn.out$num_gtCT<2)] = "ESC(+)"
table(dyn.out$type)

d00 = dyn.out[which(dyn.out$D00 & dyn.out$num_gtCT<2),]
d02 = dyn.out[which(dyn.out$D00 & dyn.out$num_gtCT<3),]

#d80 = dyn.out[which(!dyn.out$D80 & dyn.out$num_gtCT>4),]
stable = rbind( a[which(a$num_gtCT %in% 1:2 & !(paste0(a$chr1,":",a$x1) %in% dyn.name)),],
    a[which(a$num_gtCT==3),])

write.table(dyn.out[,c(2:3,15)],"dynamic_bd/dynamic.txt",row.names=F,col.names=F,quote=F,sep="\t")
write.table(d00[,2:3],"dynamic_bd/d00.txt",row.names=F,col.names=F,quote=F,sep="\t")
write.table(d02[,2:3],"dynamic_bd/d02.txt",row.names=F,col.names=F,quote=F,sep="\t")

write.table(stable[,2:3],"dynamic_bd/stable.txt",row.names=F,col.names=F,quote=F,sep="\t")





