setwd("../../analysis/tads/stage_specific_tads")
name = c("stable","CM-","CM+","ES+","ES+HERVH+")
total = c(11096,302,76, 354, 34)
hit = c( (6309+6238)/2,
         (171+173)/2,
         (33+40)/2,
         (96+91)/2,
         6)

dat = data.frame(name,total,hit)

dat$ratio = dat$hit/dat$total

pval = 1
for ( i in 2:5) {
test = matrix(c(dat[i,3],dat[i,2]-dat[i,3],dat[1,3],dat[1,2]-dat[1,3]),ncol=2)
pval[i] = prop.test(test,alternative="l")$p.value
}

pdf("conservation_with_mouse.pdf",height=3,width=3)
ggplot(dat) + geom_bar(aes(x=1:nrow(dat),y=ratio),stat="identity",fill="black") +
  scale_x_continuous(breaks=1:nrow(dat), labels=name) + xlab("") + 
  annotate("text", x=(1+2:5)/2,y= 0.6+0.05*1:4, label=format(pval[2:5],scientific=T, digits=2)) + 
  theme_bw() +  ylab("Fraction of TAD conserved in mouse") + 
  theme( axis.text.x = element_text(angle=45,hjust=1) )
  
dev.off()

