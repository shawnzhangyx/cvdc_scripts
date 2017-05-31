setwd("../../analysis/qualityControl/loop_vs_eQTL/")
options(stringsAsFactors = FALSE)
e = read.delim("eQtl.gt10kb.bed",header=F)
a1 = read.delim("eQtl.gt10kb.over.f.loop.txt",header=F)
a2 = read.delim("eQtl.gt10kb.over.r.loop.txt",header=F)
a = rbind(a1,a2)

l = read.delim("loop.anchor2.tss.txt",header=F)
l$anchor = paste(l$V1,l$V2,l$V3)
l = l[l$V4!=".",]
a$anchor = paste(a$V8,a$V9,a$V10)
m = merge(a,l, by="anchor")
length(which(m$V4.x==m$V4.y)) #55


## HICCUPS
setwd("../../analysis/qualityControl/loop_vs_eQTL/")
options(stringsAsFactors = FALSE)
e = read.delim("eQtl.gt10kb.bed",header=F)
a1 = read.delim("eQtl.gt10kb.over.hiccup.f.loop.txt",header=F)
a2 = read.delim("eQtl.gt10kb.over.hiccup.r.loop.txt",header=F)
a = rbind(a1,a2)

l = read.delim("loop.hiccup.anchor2.tss.txt",header=F)
l$anchor = paste(l$V1,l$V2,l$V3)
l = l[l$V4!=".",]
a$anchor = paste(a$V8,a$V9,a$V10)
m = merge(a,l, by="anchor")
length(which(m$V4.x==m$V4.y)) #1

