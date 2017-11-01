setwd("../../analysis/di_tads/tads_id/")
files = list.files(pattern="TAD.bed")

p.list = list()
for (file in files){
data = data.frame(fread(file))
data$width = data$V3-data$V2
data$name = sub("(D.._Rep.).TAD.bed","\\1",file)
#median = median(data$width,na.rm=T)/1000
p.list[[length(p.list)+1]] = data
}

comb = do.call(rbind,p.list)
comb$Stage = sub("(D..)_Rep.","\\1",comb$name)

source("~/gists/summarySE.r")
tgc <- summarySE(comb, measurevar="width", groupvars=c("Stage"),na.rm=T)

pdf("../figures/DI_tad_size_distribution.pdf",width=3,height=3)
  ggplot(tgc, aes(x=Stage, y=width)) + 
  geom_errorbar(aes(ymin=width-se, ymax=width+se), width=.2) +
  geom_line(aes(group=1),color='grey') +
  geom_point() + 
  theme_bw()

dev.off()

