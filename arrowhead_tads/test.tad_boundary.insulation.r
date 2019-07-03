setwd("../../data/hic/insulation")
files = list.files(pattern="ins2")
dat = list()

for(file in files){
  tmp = data.frame(fread(file))
  tmp$V3=NULL
#  tmp$name = paste(tmp$V1,tmp$V2)
  dat[[file]] =tmp
  }

dat2 = Reduce(function(...) merge(...,by = c("V1","V2")),
       dat)

setwd("../../../analysis/tads/anchors")
a=read.delim("anchors.uniq.bed",header=F)

dat3 = merge(a,dat2, by=c("V1","V2"))

dat3$min = apply(dat3[,3:14],1,min)
dat3$max = apply(dat3[,3:14],1,max)
dat3$diff = dat3$max-dat3$min
dat3 = dat3[order(-dat3$diff),]

grp = rep(c("D00","D02","D05","D07","D15","D80"),each=2)

res.aov = sapply(1:nrow(dat3), function(i){ aov(as.numeric(dat3[i,3:14])~grp)})


mat = dat3[,seq(3,14,2)]> dat3[,seq(4,14,2)]

dat4 = dat3[,seq(3,14,2)]*mat + dat3[,seq(4,14,2)]*!mat

dat4 = cbind(dat3[,c(1,2)],dat4)
dat4$min = apply(dat4[,3:8],1,min)
dat4$max = apply(dat4[,3:8],1,max)
dat4$diff = dat4$max-dat4$min
dat4 = dat4[order(-dat4$diff),]

out = dat4[which(dat4$diff> quantile(dat4$diff,0.99)),]
out$D80_D00 = out[,8]-out[,3]
out = out[order(-out$max),]

