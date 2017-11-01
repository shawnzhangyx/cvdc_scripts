setwd("../../data/tfChIPseq/")

a=read.delim("merged_peaks/CTCF_merged_peaks.peaks_by_rpkm.txt")

num = colSums(a[,-c(1:4)])
rep1 = num[c(1,3,5,7,9,11)]
rep2 = num[c(2,4,6,8,10,11)]
min = ifelse(rep1<rep2,rep1,rep2)
max = ifelse(rep1>rep2,rep1,rep2)
mean = (rep1+rep2)/2

agg = data.frame(Stage=c("D00","D02","D05","D07","D15","D80"),mean,min,max)

pdf("CTCF_peak_number_changes.pdf",width=3,height=3)
ggplot(agg, aes(x=Stage,y=mean)) +
    geom_errorbar(aes(ymin=min, ymax=max), width=.3) +
    geom_line(aes(group=1),color='grey') +
    geom_point()  + ylim(30000,45000)+ theme_bw()
dev.off()

