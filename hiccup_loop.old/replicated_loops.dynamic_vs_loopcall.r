setwd("../../analysis/hiccup_loops")

a = read.delim("replicated_loops/loops.cpb.logFC.edger.dynamic.cluster.txt")
b = read.delim("replicated_loops/loops.DegreeOfAnchors.tab")
b$name =paste(b$chr1, b$x1,b$y1)

m = merge(a,b, by="name")

m = m[order(m$cluster),]
num = table(m$cluster)
inc =0
for (i in 1:length(num)) { inc[i+1] = inc[i]+num[i] }

mat = m[,c(39:44)]
rownames(mat) = 1:nrow(mat)

melted = melt(as.matrix(mat))

ggplot(melted, aes(x=Var2,y=Var1,fill=value)) + geom_tile()+ 
  geom_hline(yintercept=inc)


cpm = m[,2:13]
ave = cpm[,seq(1,12,2)] + cpm[,seq(2,12,2)]
fc = apply(ave,1,max)/(apply(ave,1,min) +1)

