setwd("../../analysis/tads/tad_calls/")
files = list.files(pattern="TAD")

p.list = list()
for (file in files){
data = data.frame(fread(file))
data$width = data$V3-data$V2
median = median(data$width,na.rm=T)/1000
#ggplot(data, aes(x=wid)) + geom_histogram(fill=cbbPalette[3],col='black',bins=50)
p = ggplot(data, aes(x=width)) + geom_histogram(fill='grey',col='black',breaks=seq(0,6e6,by=2e5)) + annotate("text",x=4e6,y=800,label=paste0("Median: ",median,"kb"),size=3) +
    ggtitle(file)

p.list[[length(p.list)+1]] = p
}

require(gridExtra)
pdf("tad_size_distribution.pdf")
grid.arrange(grobs=p.list)
dev.off()

