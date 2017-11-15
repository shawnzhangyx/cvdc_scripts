a=read.table("D00.norm.DI")

a$dist = round((a$V6-a$V3)/40000)+10
a$name = paste(a$V1,a$V2,a$V3)
a$name = factor(a$name, levels=unique(a$name))
a$log_value = ifelse(a$V7>0, log2(a$V7),-log2(-a$V7+1))

ggplot(a[1:1000,],aes(x=dist,y=name,fill=log_value)) + geom_tile() + 
  scale_fill_gradient2(high='red',low='blue')

ggplot(a,aes(x=dist,y=log_value)) + geom_boxplot()


a=read.table("D00.insulation")

a$dist = round((a$V6-a$V3)/40000)+10
a$name = paste(a$V1,a$V2,a$V3)
a$name = factor(a$name, levels=unique(a$name))
#a$log_value = ifelse(a$V7>0, log2(a$V7),-log2(-a$V7+1))

ggplot(a[1:100,],aes(x=dist,y=name,fill=V7)) + geom_tile() +
  scale_fill_gradient2(high='red',low='blue')

ggplot(a,aes(x=dist,y=log_value)) + geom_boxplot()

