setwd("../../analysis/hiccup_loops")
a=read.delim("loops_merged_across_samples.uniq.tab")
b=read.delim("loop_anchors.uniq.30k.num_loops.txt",header=F)
b$name = paste(b$V1,b$V2+10000)
b$hub = 0

a$hub = 0
a$a1 = paste(a$chr1,a$x1)
a$a2 = paste(a$chr2,a$y1)

hub.idx = 1
while (length(which(b$hub==0 & b$V4>1))> 0 ){
  print(hub.idx)
  b$hub[which(b$hub==0)[1]] = hub.idx
  anchors = b$name[which(b$hub==hub.idx & b$V4>1)]
#  anchors = unique(c(a$a1[which(a$hub==hub.idx)],a$a2[which(a$hub==hub.idx)]))
  m = which( #a$hub==0 & 
    ( a$a1 %in% anchors | a$a2 %in% anchors))
  while ( length(which(a$hub[m]==0))> 0) {
    a$hub[m] = hub.idx 
    b$hub[which(b$name %in% c(a$a1[m],a$a2[m]))] = hub.idx
    anchors = b$name[which(b$hub==hub.idx & b$V4>1)]
    m = which( ( a$a1 %in% anchors | a$a2 %in% anchors))
  }
  hub.idx= hub.idx+1
}

write.table(a[,1:10],"hubs/loops.hub.txt",row.names=F,quote=F,sep='\t')
colnames(b)= c("chr","start","end","NumOfLoops","name","hub")

write.table(b,"hubs/anchors.hub.txt",row.names=F,quote=F,sep='\t')

