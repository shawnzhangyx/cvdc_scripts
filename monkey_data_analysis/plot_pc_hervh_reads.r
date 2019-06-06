setwd("../../analysis/monkey_hervh/rnaseq")

h1 = read.delim("calJac3.hervh.rnaseq.counts.summary")
h2 = read.delim("panTro6.hervh.rnaseq.counts.summary")
h3 = read.delim("panPan2.hervh.rnaseq.counts.summary")
h4 = read.delim("../../../analysis/hervh/rnaseq/hervh.merged.rnaseq.counts.summary")

t1 = read.delim("../../../data/rnaseq_pipe/calJac3/featureCounts/RLT_15.counts.summary")
t2 = read.delim("../../../data/rnaseq_pipe/calJac3/featureCounts/RLT_16.counts.summary")
t3 = read.delim("../../../data/rnaseq_pipe/panTro6/featureCounts/RLT_13.counts.summary")
t4 = read.delim("../../../data/rnaseq_pipe/panTro6/featureCounts/RLT_14.counts.summary")
t5 = read.delim("../../../data/rnaseq_pipe/panTro6/featureCounts/RZY932.counts.summary")
t6 = read.delim("../../../data/rnaseq_pipe/panTro6/featureCounts/RZY933.counts.summary")
t7 = read.delim("../../../data/rnaseq_pipe/panPan2/featureCounts/RZY930.counts.summary")
t8 = read.delim("../../../data/rnaseq_pipe/panPan2/featureCounts/RZY931.counts.summary")
t9 = read.delim("../../../data/rnaseq/rerun/featureCounts/RZY632_RNA_D0_1.counts.summary")
t10 = read.delim("../../../data/rnaseq/rerun/featureCounts/RZY638_RNA_D0_2.counts.summary")


r1 = h1[1,2]/t1[1,2]
r2 = h1[1,3]/t2[1,2]
r3 = h2[1,2]/t3[1,2]
r4 = h2[1,3]/t4[1,2]
r5 = h2[1,4]/t5[1,2]
r6 = h2[1,5]/t6[1,2]
r7 = h3[1,2]/t7[1,2]
r8 = h3[1,3]/t8[1,2]
r9 = h4[1,2]/t9[1,2]
r10= h4[1,8]/t10[1,2]

pc = c(r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,0,0)
sp = factor(c("CJ","CJ","PT-CM","PT-CM","PT-MT","PT-MT","PP","PP","HS","HS","MM","MM"),levels=rev(c("HS","PT-CM","PT-MT","PP","CJ","MM")))

out = data.frame(sp,pc)
out2 = aggregate(pc~sp,out,mean)

pdf("HERVH_expression.sp.pdf",height=5,width=2)
ggplot(out2) + geom_col(aes(x=sp,y=pc),width=0.5) +
  coord_flip() + theme_bw()
dev.off()


