library(data.table)
library(ggplot2)
library(gridExtra)

data_list = list()
for (name in readLines("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/hic/meta/names.txt")){
print(name)
data = data.frame(fread(paste0("zcat /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/fithic/results/",name,"/14.spline_pass2.significances.txt.gz")))
data$fragmentMid1 = data$fragmentMid1/10000
data$fragmentMid2= data$fragmentMid2/10000
data.slice = data[which(data$fragmentMid1 >= 2350 & data$fragmentMid1 <= 2420 & data$fragmentMid2 >= 2350 & data$fragmentMid2 <= 2420),]
data_list[[name]] = data.slice
}

for (idx in 1:12){
data_list[[idx]]$cutoff = ifelse(data_list[[idx]]$q.value<0.05,1,0)
data_dup = data_list[[idx]] 
frag1 = data_dup$fragmentMid1
data_dup$fragmentMid1 = data_dup$fragmentMid2
data_dup$fragmentMid2 = frag1 
data_list[[idx]] = rbind(data_list[[idx]],data_dup)
}


p_list = list()
for (idx in  readLines("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/hic/meta/names.txt")){
p_list = append(p_list,list(ggplot(data_list[[idx]], aes(x=fragmentMid1, y=fragmentMid2,fill=-log10(q.value))) + geom_tile() + scale_fill_gradient2(high='red',low='white') +ggtitle(idx) +theme(legend.position="none")

 ))
}

pdf("fithic.pval.pdf",height=10,width=20)
layout = rbind(seq(1,12,2),seq(2,12,2))
grid.arrange(grobs=p_list,nrow=2,layout_matrix=layout)
dev.off()

c_list = list()
for (idx in  readLines("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/hic/meta/names.txt")){
c_list = append(c_list,list(ggplot(data_list[[idx]], aes(x=fragmentMid1, y=fragmentMid2,fill=q.value<1e-3)) + geom_tile()  +ggtitle(idx) + theme(legend.position="none")
 ))
}

pdf("fithic.sig.pdf",height=10,width=20)
layout = rbind(seq(1,12,2),seq(2,12,2))
grid.arrange(grobs=c_list,nrow=2,layout_matrix=layout)
dev.off()


######### plot the p-value for the MYH6 loci. ######

p = list()
c = list()
for ( loc in 2385:2395){
f1 = list()
for (idx in names(data_list)){
temp = data_list[[idx]]
f1[[idx]] = cbind(temp[which(temp$fragmentMid1 == loc),],idx)
}
myh = do.call(rbind, f1)

p = append(p, list(ggplot(myh, aes(x=fragmentMid2,y=idx,fill=-log10(q.value)))+geom_tile()+
scale_fill_gradient2(high='red',low='white') + ggtitle(loc)))
c = append(c, list(ggplot(myh, aes(x=fragmentMid2,y=idx,fill=q.value<1e-5))+geom_tile()+
 ggtitle(loc)))
}

pdf("fithic.myh6.7.pval.pdf",height=30,width=10)
grid.arrange(grobs=p,ncol=1)
grid.arrange(grobs=c,ncol=1)
dev.off()


