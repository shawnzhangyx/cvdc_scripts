setwd("../../analysis/tads/")

b = read.delim("tad_calls/TAD_boundary_across_stages.tab",stringsAsFactors=F)
di = read.delim("directionality_data/combined.matrix",stringsAsFactors=F)
di = di[order(di$chrom,di$start),]

#row.list = list()
pre.list = list()
post.list= list()
for (idx in 1:nrow(b)){
print(idx)
bin_idx = which(di$chrom==b$chr[idx] & di$start < b$pos[idx] & di$end >= b$pos[idx])[1]
if ( length(which(!is.na(bin_idx))) <1) next 
bin_pre = data.frame(c(b[idx,1:2],colSums(di[(bin_idx-3):(bin_idx-1),4:15])))
bin_post = data.frame(c(b[idx,1:2],colSums(di[(bin_idx+1):(bin_idx+3),4:15])))
#row = di[which(di$chrom==b$chr[idx] & di$start < b$pos[idx] & di$end >= b$pos[idx]),]
#row.list[[length(row.list)+1]] = row
pre.list[[length(pre.list)+1]] = bin_pre
post.list[[length(post.list)+1]] = bin_post
}

#tab = do.call(rbind,row.list)
#tab$name = paste(tab$chrom,tab$start,tab$end)
#tab$name = factor(tab$name,levels=tab$name)
#tab.f = tab[,-c(1:3)]
pre = do.call(rbind,pre.list)
pre$name =  paste(pre$chr,pre$pos)
pre$name = factor(pre$name,levels=pre$name)
pre.f = pre[,-c(1:2)]
#pre.norm = apply(pre.f[,1:12],1,function(vec){sqrt(sum(vec**2))})
#pre.f[,1:12] = sweep(pre.f[,1:12],1,pre.norm, "/")
pre.f[,1:12] = sign(pre.f[,1:12]) * log(abs(pre.f[,1:12]))


post = do.call(rbind,post.list)
post$name =  paste(post$chr,post$pos)
post$name = factor(post$name,levels=post$name)
post.f = post[,-c(1:2)]
#post.norm = apply(post.f[,1:12],1,function(vec){sqrt(sum(vec**2))})
#post.f[,1:12] = sweep(post.f[,1:12],1,post.norm, "/")
post.f[,1:12] = sign(post.f[,1:12]) * log(abs(post.f[,1:12]))


pre.melted = melt(pre.f,id.vars="name",)
post.melted = melt(post.f,id.vars="name",)

pdf("tad_boundary_changes/tad_directionality_changes.pdf",height=20,width=5)
ggplot(pre.melted, aes(x=variable,y=name,fill=value)) +geom_tile() + 
  scale_fill_gradient2(high="red",low="green") + 
  theme (
      axis.text.x = element_text(angle=90,vjust=0.5),
      axis.text.y = element_blank()
    )

ggplot(post.melted, aes(x=variable,y=name,fill=value)) +geom_tile() +
scale_fill_gradient2(high="red",low="green") +
  theme (
      axis.text.x = element_text(angle=90,vjust=0.5),
      axis.text.y = element_blank()
    )

dev.off()

b$name = paste(b$chr, b$pos)
#pre.b = pre[match(b$name,pre$name),]
#pre.b$
#d80 = pre[which(pre$name %in% b$name[which(b$count.D80_replicated.TAD.txt==1 & b$total==1)]),]

#d80 = d80[order(d80$D80_1),]
#d80 = d80[order(-d80$D00_1),]


