a=read.delim("D00.rna_seq.ranked_by_rpkm.bed",header=F)
b=read.delim("rnaseq/all_gene.rnaseq_D00.out",header=F)
a$BW = b$V8[match(a$V4,b$V1)]
a=a[which(a$V6< -2),]
a$rank = 1:nrow(a)
a$tier = ceiling(a$rank/50)

exp = aggregate(BW~tier,a,median)

pdf("figures/DI.overlap.tssFC2.exp.brackets.pdf",width=4,height=10)

for (file in files[seq(1,12,2)]){
files = list.files(path="tss_DI_profile",pattern="DI",full.names=T)
file = files[1]
dat = read.delim(file,header=F)
dat = dat[which(dat$V4 %in% a$V4),]
dat$V4 = factor(dat$V4, levels=unique(dat$V4))
dat$dist = ceiling((dat$V6-dat$V2)/10000)-40
dat$rank = a$rank[match(dat$V4,a$V4)]
dat$tier = a$tier[match(dat$V4,a$V4)]
agg = aggregate(V8~tier+dist,dat[,c(12,10,8)],median)
agg$exp = exp$BW[match(agg$tier,exp$tier)]

print(
  ggplot(subset(agg, abs(dist)<10  & tier<10 )) +
  geom_bar(aes(x=dist,y=V8,fill=V8>0),stat="identity") +
  ylim(-20,20) +
  facet_grid(factor(tier)~.) +
  scale_fill_manual(values=cbbPalette[c(6,7)]) +
  theme_bw()
)
}
dev.off()
write.table(exp,"tss.tier.vs.medianBW.txt",row.names=F,quote=F,sep='\t')


#b2=read.delim("herv.rnaseq.sorted.txt",header=F)
#summary(b2$V2[1:50])

#b = re
