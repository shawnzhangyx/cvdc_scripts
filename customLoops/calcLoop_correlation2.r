setwd("../../analysis/customLoops")

loop = read.delim("loops/loops.cpb.logFC.edger.final.cluster.txt")
loop$a1 = sub("(.*) (.*) (.*)","\\1 \\2",loop$name)
loop$a2 = sub("(.*) (.*) (.*)","\\1 \\3",loop$name)


pre = read.table("loop_control_distance_matched/loop.control.pre.txt")

pos = read.table("loop_control_distance_matched/loop.control.pos.txt")

a = read.delim("anchors/anchors.uniq.30k.num_loops.txt",header=F,stringsAsFactors=F)
colnames(a)[1:3] = c("chr","start","end")
lists = list()
lists[["anchor"]] = a[,c(1:3)]
for (feature in c("H3K4me3","H3K27me3","H3K27ac","H3K4me1","rnaseq","CTCF")){
  data = read.delim(paste0("overlap_anchors_to_features/anchor.",
    feature,".norm_counts.txt"))
#  data[,c(4:9)] = sweep(data[,c(4:9)],1,apply(data[,c(4:9)],1,max),'/')
  lists[[feature]] = data
    }
m1 = Reduce(function(...)merge(..., by=c("chr","start","end"),sort=F),lists)

a = read.delim("loop_control_distance_matched/anchors.bed",header=F,stringsAsFactors=F)
colnames(a)[1:3] = c("chr","start","end")
lists = list()
lists[["anchor"]] = a[,c(1:3)]
for (feature in c("H3K4me3","H3K27me3","H3K27ac","H3K4me1","rnaseq","CTCF")){
  data = read.delim(paste0("loop_control_distance_matched/anchor.",
    feature,".norm_counts.txt"))
#  data[,c(4:9)] = sweep(data[,c(4:9)],1,apply(data[,c(4:9)],1,max),'/')
  lists[[feature]] = data
    }
m2 = Reduce(function(...)merge(..., by=c("chr","start","end"),sort=F),lists)


prom = m1[which( rowSums(m1[,28:33])>0 & rowSums(m1[,4:9]) >0 ),]

## loop that contains promoters. 
p1 = loop[which(loop$a1 %in% paste(prom$chr,prom$start+10000)),]
p2 = loop[which(loop$a2 %in% paste(prom$chr,prom$start+10000)),]

## promoter at the left anchor
rna1 = m1[match(p1$a1, paste(m1$chr,m1$start+10000)),28:33]
test1 = m1[match(p1$a2, paste(m1$chr,m1$start+10000)),]
pre_m = pre[match(p1$a1, paste(pre$V1,pre$V3)),]
control1 = m2[match(paste(pre_m$V1,pre_m$V2-10000), paste(m2$chr,m2$start)),]
control1[is.na(control1)] = 0

rna1.test = list()
rna1.control = list()
#mark="H3K27ac"
for (mark in c("H3K27ac","H3K4me1","H3K27me3")) {
print(mark)
rna1.test[[mark]] = data.frame(cluster=p1$cluster, cor =sapply(1:nrow(rna1), function(i){
  cor.test(as.numeric(rna1[i,]), as.numeric(test1[i,grep(mark,colnames(test1))]))$estimate }) ) 
rna1.control[[mark]] = data.frame(cluster=p1$cluster, cor = sapply(1:nrow(rna1), function(i){
  cor.test(as.numeric(rna1[i,]), as.numeric(control1[i,grep(mark,colnames(control1))]))$estimate }) ) 
}

## promoter at the right anchor
rna2 = m1[match(p2$a2, paste(m1$chr,m1$start+10000)),28:33]
test2 = m1[match(p2$a1, paste(m1$chr,m1$start+10000)),]
pos_m = pos[match(p2$a2, paste(pos$V1,pos$V2)),]
control2 = m2[match(paste(pos_m$V1,pos_m$V3-10000), paste(m2$chr,m2$start)),]
#control2[is.na(control2)] = 0

rna2.test = list()
rna2.control = list()
#mark="H3K27ac"
for (mark in c("H3K27ac","H3K4me1","H3K27me3")) {
print(mark)
rna2.test[[mark]] = data.frame(cluster=p2$cluster, cor =sapply(1:nrow(rna2), function(i){
  cor.test(as.numeric(rna2[i,]), as.numeric(test2[i,grep(mark,colnames(test2))]))$estimate }) )
rna2.control[[mark]] = data.frame(cluster=p2$cluster, cor = sapply(1:nrow(rna2), function(i){
  cor.test(as.numeric(rna2[i,]), as.numeric(control2[i,grep(mark,colnames(control2))]))$estimate }) ) 
}

combined.list = list()
for ( mark in c("H3K27ac","H3K4me1","H3K27me3"))
  {
  combined.list[[length(combined.list)+1]] = data.frame(mark=mark,type="Loop",rbind(rna1.test[[mark]],rna2.test[[mark]]))
  combined.list[[length(combined.list)+1]] = data.frame(mark=mark,type="Control",rbind(rna1.control[[mark]],rna2.control[[mark]]))
}

combined.stats = do.call(rbind,combined.list)
combined.stats$type2 = ifelse(combined.stats$type=="Control", "Control",
    ifelse(combined.stats$cluster>0, "Loop-Dynamic","Loop-Static"))
combined.stats$type2 = factor(combined.stats$type2,levels=c("Loop-Dynamic","Loop-Static",
  "Control"))

pdf("figures/anchor.mark.correlation.pdf",height=3,width=6)
ggplot(combined.stats, aes(x=mark, fill=type2, y=cor)) + 
  geom_boxplot(position=position_dodge(0.6),width=0.5) + 
  geom_hline(yintercept=0,linetype="dashed") + 
  scale_fill_brewer(palette="RdBu",name="Type") + ylab("Pearson Correlation") +
  theme_bw()
dev.off()





