
setwd("../../analysis/tads")

ctcf = read.delim("overlap_anchors_to_features/anchor.CTCF.norm_counts.txt")
ctcf$name = paste(ctcf$chr,ctcf$start+25000)
ctcf$peak = rowSums(ctcf[,4:9]) > 0

ctcf_peaks = data.frame(fread("overlap_anchors_to_features/anchor.CTCF_merged_peaks.txt"))
ctcf_peaks$name = paste(ctcf_peaks$V1, ctcf_peaks$V2+25000)
stages = read.table("../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.overlap_stage.edger.txt")
ctcf_stages = merge(ctcf_peaks,stages,by.x="V7",by.y="V4")
ctcf_stages = ctcf_stages[,c(10,1,14:19)]
ctcf_stages$All = 1
colnames(ctcf_stages) = c("name","peak","D00","D02","D05","D07","D15","D80","All")
ctcf_anchor_stages = aggregate(cbind(D00,D02,D05,D07,D15,D80,All)~name,ctcf_stages,FUN=sum)
ctcf_anchor_stages2 = data.frame(name=ctcf$name,ctcf_anchor_stages[match(ctcf$name,ctcf_anchor_stages$name),2:8])
ctcf_anchor_stages2[is.na(ctcf_anchor_stages2)] = 0

boundary_ctcf_list = list()
boundary_ctcf_both_list = list()
boundary_ctcf_peaks = list()
boundary_ctcf_signal = list()

gplot_list = list()
for ( name in c("stable","D00","D80","gain")) {
  tads = read.table(paste0("stage_specific_tads/",name,".unique.tads"))
  tads$a1 = paste(tads$V1,tads$V2)
  tads$a2 = paste(tads$V1,tads$V3)

  boundary_ctcf_list[[name]] =apply(ctcf_anchor_stages2[which(ctcf_anchor_stages2$name %in% c(tads$a1,tads$a2)),2:8]>0,2,table)
  a1 = ctcf_anchor_stages2[match(tads$a1,ctcf_anchor_stages2$name),2:8] 
  a2 = ctcf_anchor_stages2[match(tads$a2,ctcf_anchor_stages2$name),2:8]
  boundary_ctcf_both_list[[name]] =apply(a1*a2>0, 2, table)

}

mat1 = as.matrix(data.frame(lapply(boundary_ctcf_list,function(tab){ tab[2,]/colSums(tab) })))
mat2 = as.matrix(data.frame(lapply(boundary_ctcf_both_list,function(tab){ tab[2,]/colSums(tab) })))
colnames(mat1) = colnames(mat2) = c("stable","ES+","CM-","CM+")
melted1 = melt(mat1)
melted2 = melt(mat2)


fisher.test(rbind(boundary_ctcf_both_list$stable[,7],boundary_ctcf_both_list$D00[,7]))
# 2.3e-10
fisher.test(rbind(boundary_ctcf_both_list$stable[,7],boundary_ctcf_both_list$D80[,7]))
# 0.13
fisher.test(rbind(boundary_ctcf_both_list$stable[,7],boundary_ctcf_both_list$gain[,7]))
# 0.37

#library(gridExtra)
pdf("figures/TAD.boundary.CTCF.pdf",height=4,width=3.5)
ggplot(subset(melted2,Var1=="All"), aes(x=Var2, y=value)) +
  geom_bar(stat="identity",position="dodge",color='gray20',size=0.1) +
#  scale_fill_brewer(palette="RdBu",direction=-1)+ 
  ylim(0,1) +
  xlab("") + ylab("Fraction") + ggtitle("TAD boundary marked by CTCF") +
  #theme_bw()  +
  theme( 
    legend.text = element_text(size=5),
    axis.text.x = element_text(size=12,face="bold"),
    panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank()
  )



ggplot(subset(melted2,Var1!="All"), aes(x=Var2, y=value,fill=Var1)) +
  geom_bar(stat="identity",position="dodge",color='gray20',size=0.1) +
  scale_fill_brewer(palette="RdBu",direction=-1)+ ylim(0,1) +
  xlab("") + ylab("Fraction") + ggtitle("TAD boundary marked by CTCF") +
  theme_bw() + 
  theme( legend.text = element_text(size=5),
    axis.text.x = element_text(size=12,face="bold")
  )

#ggplot(melted2, aes(x=Var2, y=value,fill=Var1)) +
#  geom_bar(stat="identity",position="dodge",color='gray20',size=0.1) +
#  scale_fill_brewer(palette="Blues",direction=-1) + ylim(0,1)+ 
#  xlab("") + ylab("Fraction") + ggtitle("Both TAD boundary marked by CTCF") +
# theme_bw()
dev.off()

