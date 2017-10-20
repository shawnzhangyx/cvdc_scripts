setwd("../../analysis/h3k27me3_loop")

a1 = read.table("loops/anchor1.bed")
a2 = read.table("loops/anchor2.bed")
a1g = read.table("loops/anchor1.gene.txt")
a2g = read.table("loops/anchor1.gene.txt")

g = rbind(a1g,a2g)
g$name = paste(g$V1,g$V2)
g2 = aggregate(V4~name,g, function(vec){ paste(sort(unique(vec)),collapse=',')})


# if both a1 and a2 are overlaping with peak. 
lp = cbind(a1,a2)
lp2 = lp[which(lp[,4]>0 & lp[,8]>0),c(1:3,5:7)]
lp2 = lp2[order(lp2[,1],lp2[,2],lp2[,5]),]
lp2$name = paste(lp2[,1],lp2[,2],lp2[,5])
lp2$distance = lp2[,5]-lp2[,2]
lp2$a1 = paste(lp2[,1],lp2[,2])
lp2$a2 = paste(lp2[,4],lp2[,5])


anno = read.delim("../customLoops/loops/loops.cpb.logFC.edger.final.cluster.txt")
lp3 = anno[match(lp2$name,anno$name),]
lp3$distance = lp2$distance

lp2$cluster = anno$cluster[match(lp2$name,anno$name)]

lp4 = lp2[which(lp2$cluster==1),]

nodes = data.frame(id=unique(c(lp4$a1,lp4$a2)) )
links = lp4[,c(9,10,11)]
colnames(links) = c("from","to","cluster")

library(igraph)
net <- graph_from_data_frame(d=links, vertices=nodes, directed=F) 
E(net)$edge.color <- "red"

pdf("H3K27me3_multi_loops.pdf",height=15,width=15)
#plot(net,vertex.label=NA,vertex.size=2,edge.width=5,edge.color=rainbow(5)[links$cluster+1])
plot(net,vertex.label=NA,vertex.size=2,edge.width=5)
plot(net,vertex.size=2,edge.width=5)
plot(net,vertex.size=2,edge.width=5,vertex.label=g2$V4[match(nodes$id,g2$name)])
dev.off()

#plot(net,vertex.size=1,edge.width=5,edge.color=rainbow(5)[links$cluster+1])

out1 = lp2[,1:3]
out1$a2 = paste0(lp2[,4],":",lp2[,5],"-",lp2[,6],",1")
out1$strand="+"
out2 = lp2[,4:6]
out2$a2 = paste0(lp2[,1],":",lp2[,2],"-",lp2[,3],",1")
out2$strand="-"
colnames(out2) = colnames(out1)
out = rbind(out1,out2)
out = out[order(out$V1,out$V2),]
out$name = 1:nrow(out)
out = out[,c(1:4,6,5)]
write.table(out,"loops/H3K27me3.cluster.1.bed",row.names=F,col.names=F,sep='\t',quote=F)

out = cbind( paste0(lp2[,1],":",lp2[,2],"-",lp2[,3]) , 
             paste0(lp2[,4],":",lp2[,5],"-",lp2[,6]) , 1)

write.table(out,"loops/H3K27me3.cluster.1.WashU.txt",row.names=F,col.names=F,sep='\t',quote=F)


