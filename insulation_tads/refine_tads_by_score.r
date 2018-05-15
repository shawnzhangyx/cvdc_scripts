setwd("../../analysis/tads")
library(stringr)
a= read.delim("combined_tads.uniq.gt1.txt")
# remove unreplicated tads. 
#a = a[which(a$num_rep>1),]

a$D00 = grepl("D00",a$samples)
a$D02 = grepl("D02",a$samples)
a$D05 = grepl("D05",a$samples)
a$D07 = grepl("D07",a$samples)
a$D15 = grepl("D15",a$samples)
a$D80 = grepl("D80",a$samples)
a$num_stages = rowSums(a[,7:12])

a$name = paste(a$chr1,a$x1,a$x2)
c=read.delim("combined_tads.uniq.gt1.ins_mean.txt")
c$name = paste(c$chr,c$x1,c$x2)
c=c[match(a$name,c$name),]

ave = (c[,seq(4,15,2)]+ c[,seq(5,15,2)])/2
diff = abs(c[,seq(4,15,2)]- c[,seq(5,15,2)])
diff_all = unlist(diff)
grp_diff = NULL

true = data.frame(score=c[,-c(1:3,16)][a[,c(rep(7:12,each=2))]==TRUE],class="true")
false = data.frame(score=c[,-c(1:3,16)][a[,c(rep(7:12,each=2))]==FALSE],class="false")
dat = rbind(true,false)

cutoff = quantile(true$score,0.05,na.rm=T)
quantile(false$score,0.5,na.rm=T)

#ggplot(dat, aes(score, fill = class)) + geom_histogram(alpha = 0.2)  +
#  geom_vline(xintercept=cutoff)


for (i in 1:nrow(a)){
  if ( a$num_stages[i] == 6){ grp_diff[i] = 0 } 
  else {
#    upper = min(as.numeric(c[i,rep(which(a[i,16:21]==1),each=2)*2+c(-1,0)+3]))
#    lower = max(as.numeric(c[i,rep(which(a[i,16:21]==0),each=2)*2+c(-1,0)+3]))
    upper = median(as.numeric(c[i,rep(which(a[i,7:12]==1),each=2)*2+c(-1,0)+3]))
    lower = median(as.numeric(c[i,rep(which(a[i,7:12]==0),each=2)*2+c(-1,0)+3]))
    grp_diff[i] = upper-lower
    }
    }
out= cbind(a[,c(1:3,7:12)],c[,4:15],grp_diff)
out$sig = out$grp_diff> quantile(diff_all,0.90,na.rm=T)

sig = out[which(out$sig==TRUE),]

states = sig[,c(4:9)]
states.od = states[ order(#rowSums(states),
  states$D00,states$D02,states$D05,states$D07,states$D15,states$D80),]
rownames(states.od) = 1:nrow(states)
melted = melt(as.matrix(states.od))
## hierarchical clustering. 
scores = (sig[,seq(10,21,2)] + sig[,seq(11,21,2)])/2
cor = cor(t(scores))
hc = hclust(as.dist(1-cor))
scores.hc = scores[hc$order,]
scores.od = scores[order(#rowSums(states),
  states$D00,states$D02,states$D05,states$D07,states$D15,states$D80),]

rownames(scores.od) = 1:nrow(scores.od)
scmelted = melt(as.matrix(scores.od))
rownames(scores.hc) = 1:nrow(scores.hc)
hcmelted = melt(as.matrix(scores.hc))

pdf("figures/dynamic_tad_changes.pdf",height=3.5,width=3)
#ggplot(melted) + geom_tile(aes(x=Var2,y=Var1,fill=value)) + 
#    scale_fill_manual(values=c("white","black")) + 
#    theme_minimal()
ggplot(scmelted, aes(x=substr(Var2,1,3),y=Var1,fill=value)) +geom_tile() +
#    scale_fill_gradientn(colors=cbbPalette[c(6,9,7)],name='corner\nscore') +
    scale_fill_gradientn(colors=c("#2c7fb8","white","#de2d26"),name='insulation\nscore') +
    theme_classic() + xlab("") + ylab("") +
    theme(
    #legend.justification = c("right", "top")
    axis.text.y = element_blank(),
    axis.text.x = element_text(angle=90,size=12,face="bold",vjust=0.5),
#    legend.position="top"
    )

#ggplot(hcmelted, aes(x=substr(Var2,1,3),y=Var1,fill=value)) +geom_tile() +
#    scale_fill_gradientn(colors=cbbPalette[c(6,9,7)]) +
#    theme_minimal()
dev.off()

sig = sig[order(-sig$grp_diff),]
sig[,10:21] = format(sig[,10:21],digits=2)
write.table(out, "combined_tads.uniq.score.diff.txt",row.names=F,sep='\t',quote=F)
write.table(sig, "combined_tads.uniq.score.sig.diff.txt",row.names=F,sep='\t',quote=F)



