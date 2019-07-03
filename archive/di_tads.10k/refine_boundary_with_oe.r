setwd("../../analysis/di_tads.10k/oe_median2")
files = list.files(pattern="overlap.txt")


dat = list()
for (file in files){
  print(file)
  tmp = fread(file)
  tmp = tmp[which(tmp$V6 == tmp$V3-2e5-1),c(4,8)]
  tmp$name = substr(file,1,12)
  dat[[file]] = tmp
  }

dat2 = data.frame(do.call(rbind,dat))
dat3 = reshape(dat2,idvar="V4",timevar="name",direction="wide")
#dat3 = dcast(dat2, V8~V4+name)
dat3 =dat3[!is.na(rowSums(dat3[,-1])),]
dat4 = dat3

library(preprocessCore)
#dat4[,-1] = normalize.quantiles(as.matrix(dat4[,-1]))
# quantile normalization biases the data. 
diff = abs(dat4[,seq(2,13,2)]-dat4[,seq(3,13,2)])
#CUTOFF = quantile(unlist(diff),0.999)
CUTOFF=.3
ave = (dat4[,seq(2,13,2)]+dat4[,seq(3,13,2)])/2

stageDiff =  ave[,2:6]-ave[,1:5]
# remove non-boundary 
minV = apply(ave,1,min)
maxV = apply(ave,1,max)
BD = 0.7

#dynamic = which( rowSums(abs(stageDiff) > CUTOFF)>0 & minV < BD & maxV > BD-0.2 )
dynamic = which( maxV-minV > CUTOFF & minV < BD & maxV > BD-0.1 )


dat5 = cbind(dat4[,1],ave,minV)[dynamic,]
colnames(dat5)[1] = "name"
dat5$chr = sub("(chr.*):(.*)","\\1",dat5[,1])
dat5$pos = as.numeric(sub("(chr.*):(.*)","\\2",dat5[,1]))

dat5 = dat5[order(dat5$chr,dat5$pos),]
num = 1
pre = dat5$pos[1]
for( i in 1:nrow(dat5)) {
  if ( abs(dat5$pos[i]-pre) <= 50000 ) {
    dat5$grp[i] = num 
    }  else {
    num = num + 1
    pre = dat5$pos[i]
    dat5$grp[i] = num
    }
  }
dat5 = dat5[order(dat5$minV),]
# remove redundant boundaries. 
dat5 = dat5[!duplicated(dat5$grp),1:7]

# corelate with 1-6 vector
#cor = sapply(1:nrow(dat5),function(i){ cor(as.numeric(dat5[i,-1]),1:6)})
#dat5 = dat5[order(cor),]
# hierarchical clustering. 
#cor = cor(t(dat5[,-1]))
#hc = hclust(as.dist(1-cor))
#dat5 = dat5[hc$order,]
# kmeans clustering
set.seed(1)
km = kmeans(dat5[,-1],4,100,nstart=100)
#km$cluster = c(3,4,1,2)[km$cluster]
dat5 = dat5[order(km$cluster),]

dat5$name = factor(dat5$name,levels=dat5$name)
melted = melt(dat5)
#ggplot(melted) + geom_tile(aes(x=variable,y=name,fill=value)) + 
#scale_fill_gradientn(colors=c("darkblue","lightblue","red"),values=c(0,0.35,0.45,1) )

melted2= melted
melted2$value[melted2$value>1.2] = 1.2
pdf("../dynamic_TAD_boundaries.oe.pdf")
ggplot(melted2) + geom_tile(aes(x=variable,y=name,fill=value)) +
scale_fill_gradientn(colors=c("darkblue","darkblue","lightblue","red"),values=c(0,0.2,0.5,0.6,1) ) +
    theme_bw() + 
    theme(
        axis.text.x=element_text(angle=90),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()
        )
dev.off()
out = dat5
out$cluster = km$cluster[order(km$cluster)]

write.table(out,"../TAD_boundary.dynamic.txt",row.names=F,quote=F,sep='\t')





