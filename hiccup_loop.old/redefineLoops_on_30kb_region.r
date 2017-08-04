setwd("../../analysis/hiccup_loops/")

loop = read.delim("loops_merged_across_samples.uniq.tab")

k10 = read.delim("loops_merged.uniq.10k.mat.txt")

names = strsplit(as.character(loop$Samples[which(loop$TotalNumSampleLoopsCalled==12)][1]),',')[[1]]

peak = matrix(0,nrow=nrow(loop),ncol=length(names))
peak = t(sapply(1:nrow(mat),function(i){ sapply(1:12,function(x){grepl(names[x],loop$Samples[i])}) } ))
colnames(peak) = names
rownames(peak) = loop$loopID

files = list.files(pattern="30k.txt",path="contacts_by_samples",full.names=T)
k30.list = list()
for (i in 1:length(files)){
  print(files[i])
  k30.list[[length(k30.list)+1]] = read.delim(files[i])
  }

mean.list = list()
for (i in 1:12){
  print(i)
  tmp = k30.list[[i]]
  tmp = tmp[-which(tmp$X. == tmp$x1 & tmp$y2 == tmp$y1),]
  mean.list[[i]] = aggregate(contacts~chr+x1+y1,tmp,FUN=function(vec){sum(vec)/8})
  }

bg = Reduce(function(...)merge(...,by = c("chr","x1","y1")),mean.list)
colnames(bg)[-c(1:3)] = names
m = merge(k10,bg,by=c("chr","x1","y1"))

pval = t(sapply(1:nrow(m), function(i)ppois(as.numeric(m[i,4:15]),as.numeric(m[i,16:27]),lower.tail=F)))

colnames(pval) = names
rownames(pval) = paste(m$chr,m$x1,m$y1)
peak.m = peak[match(rownames(pval),rownames(peak)),]


x.p = as.numeric(pval)
y.p = as.vector(peak.m)
comb = data.frame(x.p,y.p)
#ggplot(comb,aes(x=-log10(x.p),group=y.p,fill=y.p)) + geom_histogram()
#lg = glm(y.p~ -log10(x.p), family=binomial(link="logit"),data=comb)
sig = pval<0.05
single = sig[,seq(1,12,2)] | sig[,seq(2,12,2)]
dup = sig[,seq(1,12,2)]
### call a loop replicable if there is at least two peaks in the adjacent stage. 
for (i in 1:6){
#  start = ifelse((i-1)*2-1<0,1,(i-1)*2-1)
#  end = ifelse(i*2+2>12,12,i*2+2)
#  dup[,i] =  rowSums(sig[,(i-1)*2+c(1,2)])>0 & rowSums(sig[,start:end])>=2
   start = max(1,i-1)
   end = min(6,i+1)
# call a loop if found in both replicates or in at least two adjacent stages.
  dup[,i] = rowSums(sig[,(i-1)*2+c(1,2)]) == 2 | rowSums(single[,start:end])>=2
}

#dup = pval[,seq(1,12,2)] <0.05 | pval[,seq(2,12,2)]<0.05

out = dup[which(rowSums(dup)>0),]
colnames(out) = c("D00","D02","D05","D07","D15","D80")
out2 = cbind(loop[match(rownames(out),loop$loopID),2:7],out)
out2$TotalNumOfStages = rowSums(out2[,7:12])
write.table(out2, "loops_merged_across_samples.uniq.replicated.tab",row.names=F,sep='\t',quote=F)

#sig = pval<0.01


#mat.list = list()
#for (i in 1:12){
#  print(i)
#  tmp = k30.list[[i]]
#  tmp = tmp[which(tmp$chr=="chr14" & tmp$x1== "23870000"),]
#  tmp$sample = names[i]
#  mat.list[[length(mat.list)+1]] = tmp
#  }
#mat.out = do.call(rbind,mat.list)
#
#core = mat.out[which(mat.out$X.==mat.out$x1 & mat.out$y2 == mat.out$y1),]
#ave = aggregate(contacts~chr+x1+y1+sample,mat.out[-which(mat.out$X.==mat.out$x1 & mat.out$y2 == mat.out$y1),],FUN=mean)
##ave = aggregate(contacts~chr+x1+y1+sample,mat.out,FUN=function(vec){mean(vec[-which.max(vec)])} )
#ppois(core$contacts,ave$contacts,lower.tail=F)
#
#
#ggplot(mat.out, aes(x=X., y=y2,fill=contacts)) + geom_tile()+
#  facet_wrap(~sample) 
#
#
