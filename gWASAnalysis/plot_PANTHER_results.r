setwd("../../analysis/gWAS")

#archive
a=read.delim("PANTHER_analysis.txt",skip=6)
a=a[which(a$upload_1..over.under. =="+"),]

pdf("PANTHER_enrichment_testing.pdf",height=3,width=5)
ggplot(a,aes(x=GO.biological.process.complete, y=-log10(upload_1..P.value.))) + 
    geom_bar(stat="identity",fill=cbbPalette[6]) +
    geom_hline(yintercept=-log10(0.05),linetype="dashed")+
    coord_flip() + xlab("") + ylab("-log10 Bonferroni p-value") + 
    theme_bw()
dev.off()



a=read.delim("PANTHER_analysis2.txt",skip=11,stringsAsFactors=F)
a=a[which(a$upload_1..over.under. =="+"),]
b = a[,c(1,6,7)]
colnames(b) = c("name","FC","pval")
b = b[-which(b$FC ==" > 100"),]
b$FC = as.numeric(b$FC)

library(ggrepel)
png("PANTHER_enrichment_testing.png")
#pdf("PANTHER_enrichment_testing.pdf",width=5,height=5)
ggplot(b,aes(x=FC,y=-log10(pval))) +
    geom_point(color="grey") +
    geom_hline(yintercept=-log10(0.05),linetype="dashed")+
    geom_point(data=subset(b,pval<0.05), aes(x=FC,y=-log10(pval)),size=3,color="black") +
    geom_label_repel(data=subset(b,pval<0.05), 
        aes(x=FC,y=-log10(pval),label=name),
        fontface = 'bold',size=4,box.padding = 1,point.padding = 2,segment.color='black') +
    theme_bw()
dev.off()

