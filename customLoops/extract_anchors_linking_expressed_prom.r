setwd("../../analysis/customLoops")

loop = read.delim("loops/loops.cpb.logFC.edger.final.cluster.txt")
loop$a1 = sub("(.*) (.*) (.*)","\\1 \\2",loop$name)
loop$a2 = sub("(.*) (.*) (.*)","\\1 \\3",loop$name)
#loop = loop[which(loop$cluster>1),]



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

prom = m1[which( apply(m1[,29:33],1,max)>100 & rowSums(m1[,4:9]) > 0 ),]

## loop that contains promoters. 
p1 = loop[which(loop$a1 %in% paste(prom$chr,prom$start+10000)),]
p2 = loop[which(loop$a2 %in% paste(prom$chr,prom$start+10000)),]

## promoter at the left anchor
test1 = m1[match(p1$a2, paste(m1$chr,m1$start+10000)),]

test2 = m1[match(p2$a1, paste(m1$chr,m1$start+10000)),]

write.table(rbind(test1[,1:3],test2[,1:3]),"gWAS/anchors_connect_to_expressed_gene_D2-80.txt",row.names=F,col.names=F,quote=F,sep='\t')




