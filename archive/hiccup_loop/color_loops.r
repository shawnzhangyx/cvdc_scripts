setwd("../../analysis/hiccup_loops/")

a = read.delim("combined_loops.uniq.txt",stringsAsFactors=F)
b=read.delim("loops/loops.cpb.logFC.edger.dynamic.cluster.txt")

a$name = paste(a$chr1,a$x1,a$y1)
a$color = "122,122,122"
a$color[match(b$name,a$name)] = c("255,255,0","255,255,0","122,255,0","122,122,0","0,0,125","0,0,255")[b$cluster]
a$cluster = 0 
a$cluster[match(b$name,a$name)] =b$cluster 
write.table(a[,-8],"combined_loops.uniq.color.txt",row.names=F,sep='\t',quote=F)

