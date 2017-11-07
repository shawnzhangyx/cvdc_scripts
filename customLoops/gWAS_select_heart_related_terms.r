setwd("../../analysis/customLoops/gWAS")

a =read.delim("LD_SNP.clusters2-5.out")

heart_traits = c(
  "Atrial fibrillation",
  "Cardiac repolarization",
  "Coronary heart disease",#
  "Conotruncal heart defects",#
  "Congenital left-sided heart lesions",
  "Congenital heart disease",
  "Congenital heart malformation",#
  "Heart failure",
  "Mortality in heart failure",#
  "PR interval",
  "QRS duration",
  "QT interval",
  "Sudden cardiac arrest")

b = a[which(a$V6 %in% heart_traits),]

pdf("../figures/heartGWAS_enrichment.pdf",width=5,height=3)
ggplot(b, aes(x=V6,y=-log10(pval))) + geom_bar(stat="identity",fill=cbbPalette[6]) + 
  geom_hline(yintercept=-log10(0.05),linetype="dashed") + 
  coord_flip() +
  theme_bw() + xlab("") + ylab("-log10 pvalue")
#  theme( axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()

