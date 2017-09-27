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
c=read.delim("combined_tads.insu_median.txt")
c$name = paste(c$chr,c$x1,c$x2)
#c=c[match(a$name,c$name),]
b = cbind(c[,-16],a[match(c$name,a$name),16:21])

true = data.frame(counts=b[,4:15][b[,rep(16:21,each=2)]==TRUE],class="true")
false = data.frame(counts=b[,4:15][b[,rep(16:21,each=2)]==FALSE],class="false")
dat = rbind(true,false)
ggplot(dat, aes(counts, fill = class)) + geom_histogram(alpha = 0.2) +xlim(0,3)

#test1 = b[which(b$D00==TRUE),]
#head(test1[order(test1$D00_HiC_Rep1),])
#test2 = b[which(b$D00==FALSE),]
#head(test2[order(-test2$D00_HiC_Rep1),])

outoff = quantile(true$counts,0.2)
peaks = b[,4:15]>cutoff
peaks_rep = peaks[,seq(1,12,2)] *peaks[,seq(2,12,2)]
#colSums( peaks[,seq(1,12,2)] *peaks[,seq(2,12,2)])
#colSums( peaks[,seq(1,12,2)] + peaks[,seq(2,12,2)] >0)
b2 = cbind(b[,1:15],peaks_rep)

# table(rowSums(peaks_rep))
#  0    1    2    3    4    5    6
#  2106 1583 1003  820 1134 1404 4138
b3 = b2[which(rowSums(b2[,16:21])>0),]
colnames(b3)[16:21]=c("D00","D02","D05","D07","D15","D80")
cand = b3[which(rowSums(b3[,16:21])<6),]
design = cand[,rep(16:21,each=2)]
diff = rowSums(cand[,4:15] *design)/rowSums(design) - 
   rowSums(cand[,4:15] * (1-design) )/rowSums(1-design)
cand$diff = diff

diffPool = unlist(abs(b[,seq(4,15,2)]-b[,seq(5,15,2)]))

diffSig = cand[which(cand$diff > quantile(diffPool,0.995)),]
diffSig = diffSig[order(-diffSig$diff),]
write.table(b3, "combined_tads.uniq.final.txt",row.names=F,quote=F,sep='\t')
write.table(diffSig, "combined_tads.sigDiff.txt",row.names=F,quote=F,sep='\t')


