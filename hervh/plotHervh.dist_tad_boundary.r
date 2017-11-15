
a=read.table("hervh.sorted_rnaseq.bed")
b=read.table("hervh.dist.tad_boundary.txt")
a$rank = 1:nrow(a)
m = merge(a,b,by=c("V1","V2","V3"))
m = m[order(m$rank),]

log10(m$V7+1))

ggplot(m,aes(x=rank,y=V7)) +geom_point() + geom_smooth() + 
  scale_y_log10()


