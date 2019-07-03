setwd("../../analysis/hiccup_loops/")
# edgeR test
all = read.delim("edgeR/loops_edgeR_test_allStage.txt")
# contact count per billion
cpb = read.delim("edgeR/loops_cpb.txt")
# loop
s = read.delim("loops_merged_across_samples.uniq.tab")
s$distance = s$y1-s$x1
cpb$max = apply(cpb,1,max)
cpb$name = rownames(cpb)
all$name = paste(all$chr,all$x1,all$y1)
combined = merge(cpb,all,by="name")
combined = cbind(combined,s[match(combined$name,s$loopID),c(8,9,10)])

## begin calculation
combined$fdr = p.adjust(combined$PValue)
combined$dynamic = combined$fdr<0.05

## plot the dynamic peaks by Total Number of samples. 
pdf("figures/loops.dynamic_vs_NumSamples.pdf")
ggplot(combined, aes(x=TotalNumSampleLoopsCalled,group=dynamic,fill=dynamic)) + 
  geom_histogram()
ggplot(combined, aes(x=TotalNumSampleLoopsCalled,fill=dynamic)) +
  geom_bar(position="fill",stat="count")
dev.off()

#files = list.files(pattern="loops_edgeR_test_D..-D...txt",path="edgeR",full.names=T)
#adj.list = list()
#for (file in files){
#  adj.list[[length(adj.list)+1]] = read.delim(file)
#  }
#adj.tab = do.call(cbind, adj.list)[,c(seq(7,40,8),seq(8,40,8))]
#adj.tab$name = paste(adj.list[[1]]$chr,adj.list[[1]]$x1,adj.list[[1]]$x2)
#sapply(6:10,function(x){length(which(adj.tab[,x]<0.01))})
# [1] 1197  281   10   80 4144

write.table(combined,"loops.cpb.logFC.edger.final.txt",quote=F,sep='\t')
write.table(combined[combined$dynamic==TRUE,],"loops.cpb.logFC.edger.dynamic.txt",quote=F,sep='\t')
write.table(combined[!combined$dynamic==TRUE,],"loops.cpb.logFC.edger.nondynamic.txt",quote=F,sep='\t')

#d = combined[which(combined$dynamic==TRUE),]


