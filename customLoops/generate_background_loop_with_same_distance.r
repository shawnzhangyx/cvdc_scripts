setwd("../../analysis/customLoops")
loop=read.delim("combined_loops.uniq.gt1.txt")

set1 = loop[,1:3]
set1$alt = set1$x*2-set1$y
set1 = set1[,c(1,4,2)]
set1 = set1[which(set1$alt>=10000),]

set2 = loop[,1:3]
set2$alt = set2$y*2-set2$x
set2 = set2[,c(1,3,4)]

anchors = rbind(set1[,c(1,2)],set2[,c(1,3)])
anchors$alt = anchors$alt-10000
anchors$end = anchors$alt+30000
anchors2 = anchors[!duplicated(anchors),]


write.table(set1,"loop_control_distance_matched/loop.control.pre.txt",row.names=F,col.names=F,sep='\t',quote=F)
write.table(set2,"loop_control_distance_matched/loop.control.pos.txt",row.names=F,col.names=F,sep='\t',quote=F)
write.table(anchors2,"loop_control_distance_matched/anchors.bed",row.names=F,col.names=F,sep='\t',quote=F)

