setwd("../../data/tfChIPseq")

peaks = data.frame(fread("merged_peaks/CTCF_merged_peaks.overlap_stage.txt"))
rpkm = data.frame(fread("counts/CTCF.rpkm"))

true = data.frame(rpkm=rpkm[,-c(1:6)][peaks[,rep(5:8,each=2)]==TRUE],class="true")
false = data.frame(rpkm=rpkm[,-c(1:6)][peaks[,rep(5:8,each=2)]==FALSE],class="false")
dat = rbind(true,false)

cutoff = quantile(true$rpkm,0.05)
quantile(false$rpkm,0.5)

#ggplot(dat, aes(rpkm, fill = class)) + geom_histogram(alpha = 0.2) +xlim(0,100) +
#  geom_vline(xintercept=cutoff)

peaks2 = rpkm[,-c(1:6)]>cutoff
peaks_rep = peaks2[,seq(1,8,2)] * peaks2[,seq(2,8,2)] #>0

# combined counts and peak_rep 
combined = cbind(rpkm,peaks_rep)
cand = combined[which(rowSums(peaks_rep) %in% 1:3 ),]
design = cand[,rep(15:18,each=2)]

logFC = log (rowSums( design * cand[,7:14])/rowSums(design) /
      ( rowSums( (1-design) * cand[,7:14]) /rowSums(1-design) ) )
#cand$logFC = logFC      

logFCPool = unlist(abs(log( (rpkm[,seq(7,14,2)] +0.01) /(rpkm[,seq(8,14,2)] +0.01))))
#quantile(logFCPool,0.995)

diffSig = cand[which(logFC > quantile(logFCPool,0.95)),]
diffNonSig = cand[-which(logFC > quantile(logFCPool,0.95)),]
diffNonSig[,15:18] = 1

out.peaks = rbind(diffSig,combined[which(rowSums(peaks_rep)==4),],diffNonSig)
colnames(out.peaks)[7:18] = c(paste0(c("D00_Rep1","D00_Rep2","D02_Rep1","D02_Rep2","D07_Rep1","D07_Rep2","D15_Rep1","D15_Rep2"),".rpkm"),paste0(c("D00","D02","D07","D15"),".peak"))

write.table(out.peaks[,c(2,3,4,1,5,6,7:18)],"merged_peaks/CTCF_merged_peaks.overlap_stage.refined.txt",row.names=F,sep='\t',quote=F)

sorted = out.peaks[,15:18]
sorted = sorted[order(sorted[,1],sorted[,2],sorted[,3],sorted[,4]),]
rownames(sorted) = 1:nrow(sorted)
melted = melt(as.matrix(sorted))
jpeg("merged_peaks/CTCF_binding_over_stages.jpg",width=320,height=320)
#pdf("merged_peaks/CTCF_binding_over_stages.pdf",width=3,height=3)

ggplot(melted,aes(x=Var2,y=Var1,fill=value))+ geom_tile() + theme_minimal()
dev.off()

