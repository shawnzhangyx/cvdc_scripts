setwd("../../data/tfChIPseq/merged_peaks/")
a=data.frame(fread("CTCF_merged_peaks.overlap_stage.txt"))
a[,c(5:8)] = ifelse(a[,c(5:8)]>0,1,0)
a$total = rowSums(a[,c(5:8)])
colnames(a) = c("chr","start","end","name","D00","D02","D07","D15","total")

# load edgeR results 
b = fread("../edger/CTCF.rpkm.fc.edger.txt",check.names=F)#[,c(1,28:34)]

# D00+D02+D07-D15
fdr = p.adjust(unlist(b[,28]),method="BH")
a[which(fdr>0.05 & a$total==1 & a$D15==1),5:8] = 1
a[which(fdr>0.05 & a$total==3 & a$D15==0),5:8] = 1
#D00+D02-D07+D15
fdr = p.adjust(unlist(b[,29]),method="BH")
a[which(fdr>0.05 & a$total==1 & a$D07==1),5:8] = 1
a[which(fdr>0.05 & a$total==3 & a$D07==0),5:8] = 1
#D00+D02-D07-D15
fdr = p.adjust(unlist(b[,30]),method="BH")
a[which(fdr>0.05 & a$total==2 & a$D07+a$D15==2),5:8] = 1
a[which(fdr>0.05 & a$total==2 & a$D07+a$D15==0),5:8] = 1
#D00-D02+D07+D15
fdr = p.adjust(unlist(b[,31]),method="BH")
a[which(fdr>0.05 & a$total==1 & a$D02==1),5:8] = 1
a[which(fdr>0.05 & a$total==3 & a$D02==0),5:8] = 1
#D00-D02+D07-D15
fdr = p.adjust(unlist(b[,32]),method="BH")
a[which(fdr>0.05 & a$total==2 & a$D00+a$D07==2),5:8] = 1
a[which(fdr>0.05 & a$total==2 & a$D00+a$D07==0),5:8] = 1
#D00-D02-D07+D15
fdr = p.adjust(unlist(b[,33]),method="BH")
a[which(fdr>0.05 & a$total==2 & a$D02+a$D07==2),5:8] = 1
a[which(fdr>0.05 & a$total==2 & a$D02+a$D07==0),5:8] = 1
#D00-D02-D07-D15
fdr = p.adjust(unlist(b[,34]),method="BH")
a[which(fdr>0.05 & a$total==1 & a$D00==1),5:8] = 1
a[which(fdr>0.05 & a$total==3 & a$D00==0),5:8] = 1

a$total = rowSums(a[,c(5:8)])


a = a[order(a$total,a$D00,a$D02,a$D07,a$D15),]
#rownames(a) = 1:nrow(a)
a$name = factor(a$name, levels=a$name)
write.table(a,"CTCF_merged_peaks.overlap_stage.edger.txt",row.names=F,sep='\t',quote=F)


melted = melt(a,id.vars="name",measure.vars=c("D00","D02","D07","D15"))

pdf("CTCF_binding_over_stages.pdf")
ggplot(melted, aes(x=variable,y=name,fill=value)) + geom_tile() + 
  theme( axis.text.y = element_blank(),legend.position="n")
dev.off()

