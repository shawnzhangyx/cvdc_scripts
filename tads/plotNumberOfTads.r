setwd("../../analysis/tads/")

a=read.delim("combined_tads.uniq.final.txt")

num = colSums(a[,16:21])
dat = data.frame(names=names(num),num)

pdf("figures/TAD_number.pdf")
ggplot(dat,aes(x=names,y=num)) +geom_bar(stat="identity",fill=cbbPalette[6])
dev.off()
