setwd("../../analysis/hiccup_loops/")

rep = read.delim("loops_merged_across_samples.uniq.replicated.tab")
dyn = read.delim("loops.cpb.logFC.edger.dynamic.txt")
nondyn = read.delim("loops.cpb.logFC.edger.nondynamic.txt")

rep.id = paste(rep$chr1,rep$x1,rep$y1)
rep$dynamic = ifelse(rep.id %in% dyn$name, TRUE,FALSE)


pdf("figures/replicated_loops.dynamic_vs_NumStages.pdf")
ggplot(rep,aes(x=TotalNumOfStages,group=dynamic,fill=dynamic)) + geom_histogram(alpha=0.5)
ggplot(rep, aes(x=TotalNumOfStages,fill=dynamic)) +
  geom_bar(position="fill",stat="count")
dev.off()

d = rep[which(rep$dynamic==T),]

mat = d[order(d$TotalNumOfStages,d$D00,d$D02,d$D05,d$D07,d$D15,d$D80),c(7:12)]
rownames(mat) = 1:nrow(mat)
melted = melt(as.matrix(mat))
pdf("figures/replicated_loops.dynamic_vs_order_by_loop_calls.pdf")
ggplot(melted, aes(x=Var2,y=Var1,fill=value)) + geom_tile()+
#  facet_wrap(~value) +
  theme (
    axis.text.x = element_text(angle=90,vjust=0.5),
    axis.text.y = element_blank()
    )
dev.off()

dyn.rep = dyn[which(dyn$name %in% rep.id),]
nondyn.rep = nondyn[which(nondyn$name %in% rep.id),]

write.table(dyn.rep,"replicated_loops.cpb.logFC.edger.dynamic.txt",row.names=F,quote=F,sep='\t')
write.table(nondyn.rep,"replicated_loops.cpb.logFC.edger.nondynamic.txt",row.names=F,quote=F,sep='\t')

