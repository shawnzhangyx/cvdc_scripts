setwd("../../data/chipseq")

mark="H3K27ac"
for ( mark in c("H3K27ac","H3K27me3","H3K4me3","H3K4me1") ) {

peaks = data.frame(fread(paste0("merged_peaks/",mark,"_merged_peaks.overlap_stage.txt")))
rpkm = data.frame(fread(paste0("counts/",mark,".rpkm")))

true = data.frame(rpkm=rpkm[,-c(1:6)][peaks[,rep(5:10,each=2)]==TRUE],class="true")
false = data.frame(rpkm=rpkm[,-c(1:6)][peaks[,rep(5:10,each=2)]==FALSE],class="false")
dat = rbind(true,false)

cutoff = quantile(true$rpkm,0.05)
quantile(false$rpkm,0.5)

png(paste0("merged_peaks/",mark,".rpkm.percentile.png"))
print(ggplot(dat, aes(rpkm, fill = class)) + geom_histogram(alpha = 0.2,bins=100,position="identity") +xlim(0,quantile(true$rpkm,0.90)) + geom_vline(xintercept=cutoff))
dev.off()

peaks2 = rpkm[,-c(1:6)]>cutoff
peaks_rep = peaks2[,seq(1,12,2)] * peaks2[,seq(2,12,2)] #>0

# combined counts and peak_rep 
combined = cbind(rpkm,peaks_rep)
cand = combined[which(rowSums(peaks_rep) %in% 1:5 ),]
design = cand[,rep(19:24,each=2)]

logFC = log (rowSums( design * cand[,7:18])/rowSums(design) /
      ( rowSums( (1-design) * cand[,7:18]) /rowSums(1-design) ) )
#cand$logFC = logFC      

logFCPool = unlist(abs(log( (rpkm[,seq(7,18,2)] +0.01) /(rpkm[,seq(8,18,2)] +0.01))))
#quantile(logFCPool,0.995)

diffSig = cand[which(logFC > quantile(logFCPool,0.95)),]
diffNonSig = cand[-which(logFC > quantile(logFCPool,0.95)),]
diffNonSig[,19:24] = 1

out.peaks = rbind(diffSig,combined[which(rowSums(peaks_rep)==6),],diffNonSig)
colnames(out.peaks)[7:24] = c(paste0(c("D00_Rep1","D00_Rep2","D02_Rep1","D02_Rep2","D05_Rep1","D05_Rep2","D07_Rep1","D07_Rep2","D15_Rep1","D15_Rep2","D80_Rep1","D80_Rep2"),".rpkm"),paste0(c("D00","D02","D05","D07","D15","D80"),".peak"))

write.table(out.peaks[,c(2,3,4,1,5,6,7:24)],paste0("merged_peaks/",mark,"_merged_peaks.overlap_stage.refined.txt"),row.names=F,sep='\t',quote=F)

sorted = out.peaks[,19:24]
sorted = sorted[order(sorted[,1],sorted[,2],sorted[,3],sorted[,4],sorted[,5],sorted[,6]),]
rownames(sorted) = 1:nrow(sorted)
melted = melt(as.matrix(sorted))
png(paste0("merged_peaks/",mark,"_binding_over_stages.png"),width=640,height=640)
print(ggplot(melted,aes(x=Var2,y=Var1,fill=value))+ geom_tile())
dev.off()
}
