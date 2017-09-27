#name="D00_HiC_Rep1"
Rscript plotTad_Features.r
setwd("../../analysis/ab_compartments")
ratio = list()
for (name in readLines("../../data/hic/meta/names.txt")) {
a=read.table(paste0("ab_contacts/trans.",name,".ab.bins.txt"))
b=read.table(paste0("ab_contacts/trans.",name,".ab.contacts"))
b$V2 = b$V2/sum(as.numeric(b$V2))*1e6
ratio[[name]] = b$V2/a$V2
}
out = as.data.frame(do.call(rbind,ratio))
out$name = substr(rownames(out),1,3)
colnames(out)[1:3] = c("BB","AB","AA")

pd <- position_dodge(0.1)
g1 = ggplot(out, aes(x=name,y=BB)) + geom_point(position=pd)  + 
   stat_summary(fun.y=mean, colour="red", geom="line", aes(group = 1)) + 
   ggtitle("BB interaction")+
   theme(axis.text.x=element_text(angle=90)) + ylab("Freq")
g2 = ggplot(out, aes(x=name,y=AB)) + geom_point(position=pd)  +
   stat_summary(fun.y=mean, colour="red", geom="line", aes(group = 1)) +
   ggtitle("AB interaction")+
   theme(axis.text.x=element_text(angle=90)) + ylab("Freq")
g3 = ggplot(out, aes(x=name,y=AA)) + geom_point(position=pd)  +
   stat_summary(fun.y=mean, colour="red", geom="line", aes(group = 1)) +
   ggtitle("AA interaction")+
   theme(axis.text.x=element_text(angle=90)) + ylab("Freq")

#g1 = qplot(x=rownames(out),y=out[,1]) + ggtitle("BB interaction")+
 theme(axis.text.x=element_text(angle=90)) + ylab("Freq")

require(gridExtra)
pdf("AB_trans_interaction.pdf",width=9,height=3)
grid.arrange(g1,g2,g3,ncol=3)
dev.off()

#plot(out[,1],labels=rownames(out))
#plot(out[,2])
#plot(out[,3])

