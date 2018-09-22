setwd("../../analysis/customLoops")

anchors = read.table("anchors/anchors.uniq.30k.num_loops.red.txt")

anchors$V4[which(anchors$V4>=5)] = "5+"
com = table(anchors$V4)

dat = data.frame(com)

#ggplot(anchors, aes(V4)) + geom_histogram()
pdf("figures/multiloop_anchor/anchor_degree.pdf",height=3.5,width=3)
ggplot(dat, aes(x=Var1,y=Freq)) + geom_bar(stat="identity") + 
  xlab("Anchor Degree") + ylab("Frequency") + 
#  theme(panel.background = element_rect(fill = "white", colour = "grey50"))
  theme(panel.background = element_blank(), 
        panel.border = element_rect(linetype='solid',fill=NA)) 

dev.off()
