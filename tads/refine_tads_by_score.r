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
a$num_stages = rowSums(a[,16:21])

a$name = paste(a$chr1,a$x1,a$x2)
c=read.delim("arrowhead_test_list/combined_tads.uniq.score.txt")
c$name = paste(c$chr,c$x1,c$x2)
c=c[match(a$name,c$name),]


ave = (c[,seq(4,15,2)]+ c[,seq(5,15,2)])/2
diff = abs(c[,seq(4,15,2)]- c[,seq(5,15,2)])

#plot(ave[,1],diff[,1])
diff_all = unlist(diff)

d02.d00 = ave[,2]-ave[,1]

grp_diff = NULL

for (i in 1:nrow(a)){
  if ( a$num_stages[i] == 6){ grp_diff[i] = 0 } 
  else {
#    upper = min(as.numeric(c[i,rep(which(a[i,16:21]==1),each=2)*2+c(-1,0)+3]))
#    lower = max(as.numeric(c[i,rep(which(a[i,16:21]==0),each=2)*2+c(-1,0)+3]))
    upper = median(as.numeric(c[i,rep(which(a[i,16:21]==1),each=2)*2+c(-1,0)+3]))
    lower = median(as.numeric(c[i,rep(which(a[i,16:21]==0),each=2)*2+c(-1,0)+3]))
    grp_diff[i] = upper-lower
    }
    }

out= cbind(a[,c(1:3,16:21)],c[,4:15],grp_diff)
out$sig = out$grp_diff> quantile(diff_all,0.999)

sig = out[which(out$sig==TRUE),]

states = sig[,c(4:9)]
states = states[ order(#rowSums(states),
  states$D00,states$D02,states$D05,states$D07,states$D15,states$D80),]
rownames(states) = 1:nrow(states)
melted = melt(as.matrix(states))
pdf("dynamic_tad_changes.pdf")
ggplot(melted) + geom_tile(aes(x=Var2,y=Var1,fill=value)) + 
scale_fill_manual(values=c("white","black"))
dev.off()

sig = sig[order(-sig$grp_diff),]
sig[,10:21] = format(sig[,10:21],digits=2)
write.table(out, "combined_tads.uniq.score.diff.txt",row.names=F,sep='\t',quote=F)
write.table(sig, "combined_tads.uniq.score.sig.diff.txt",row.names=F,sep='\t',quote=F)



