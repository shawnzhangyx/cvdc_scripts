# plot the entropy values for genes with different number of loops. 
setwd("../../analysis/customLoops")
require(ggrepel)

# shannon entropy definition
shannon.entropy <- function(p)
{
        if (min(p) < 0 || sum(p) <= 0)
                return(NA)
        p.norm <- p[p>0]/sum(p)
        -sum(log2(p.norm)*p.norm)
}


a = read.table("anchors/anchors.uniq.30k.num_loops.genes.txt")
rpkm = read.delim("../../data/rnaseq/gene.rpkm.expressed.type.txt")

rpkm$numLoops = a$V4[match(rpkm$Geneid,a$V8)]
rpkm$numLoops[is.na(rpkm$numLoops)] = 0
## leave the ones that are expressed
keep = which( rowSums(rpkm[,4:15]>1)>=2 )
rpkmK = rpkm[keep,]

se = apply(rpkmK[,4:15],1,shannon.entropy)
rpkmK$se = se

rpkmK$numLoops[which(rpkmK$numLoops>=5)] = 5


pdf("figures/multiloop_anchor/anchor_loop_vs_shannon_entropy.pdf",width=4,height=4)
ggplot(rpkmK) + geom_boxplot(aes(factor(numLoops),se),fill=cbbPalette[6]) + 
  xlab("NumLoops") + ylab("Shannon Entropy") + 
  theme_bw()

dev.off()
