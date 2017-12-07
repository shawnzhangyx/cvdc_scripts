setwd("../../analysis/tads/overlap_compartments_to_tads/")

files = list.files(pattern="txt")

dat_list = list()

for (file in files){
a = read.table(file)
#a=read.table("all.compartments.switchType.txt")
dat_list[[length(dat_list)+1]] = table(a$V5)

}

dat = do.call(rbind,dat_list)
rownames(dat) = c("All","ES+","CM-","CM+")
colnames(dat) = c("A","AtoB","ABA","B","BtoA","BAB")
#rownames(dat) = sub("(.*?)\\..*","\\1",files)

melted = melt(dat)
melted$Var2 = factor(melted$Var2,levels=c("A","ABA","AtoB","BtoA","BAB","B"))


pdf("../figures/compartments_overlap_with_TADs.pdf",width=2.5,height=4)
ggplot(melted,aes(x=Var1,y=value,fill=Var2)) +
  geom_bar(stat="identity",position="fill") +
  scale_fill_brewer(palette="RdBu",name="") +
  xlab("") + ylab("Fraction") + 
  theme_bw()+
  theme( legend.position="top"
         #legend.justification="right"
         )
  dev.off()

