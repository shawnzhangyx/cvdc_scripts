setwd("../../analysis/customLoops/")
a=read.delim("overlap_anchors_to_features/anchor.all_features.txt")
b=data.frame(fread("overlap_anchors_to_features/all_genomic_bins.features.txt"))

a1 = a[,-c(1,2,3)]
a1 = a1>0
a1 = apply(a1,2,function(vec){ sum(vec)/length(vec)})
b1 = b[,-c(1,2,3)]
b1 = b1>0
b1 = apply(b1,2,function(vec){ sum(vec)/length(vec)})

melted = rbind(data.frame(factor=names(a1),ratio=a1,name="Loop anchor"), data.frame(factor=names(b1),ratio=b1,name="Genome-wide"))
melted$factor = factor(melted$factor,levels=names(a1))

pdf("figures/anchor.features.pdf",height=5,width=5)
ggplot(melted, aes(x=factor,fill=name,y=ratio)) +
    geom_bar(position="dodge",stat="identity",color='black')+ ylab("Percentage") +
#    scale_fill_brewer(palette = "BuGn",direction=-1) + 
    ylab("Fraction") + 
    scale_fill_manual(values=cbbPalette[c(6,3)]) + 
    theme_bw() + 
    theme( 
    axis.text.x = element_text(size=15,angle = 90, hjust = 1))
dev.off()

