
me1 = data.frame(fread("overlaped_histone/atac_summits.H3K4me1.stages.txt"))
k27 = data.frame(fread("overlaped_histone/atac_summits.H3K27me3.stages.txt"))
ac = data.frame(fread("overlaped_histone/atac_summits.H3K27ac.stages.txt"))

states = me1
for (i in 6:11){
print(i)
states[,i] = ifelse(ac[,i]>0,"activated", 
              ifelse(k27[,i]>0,"poised",
                ifelse(me1[,i]>0,"primed","latent")))
                }

states = states[order(states$D00,states$D02,states$D05,states$D07,states$D15,
        states$D80),]

mat = as.matrix(states[,6:11])
rownames(mat) = 1:nrow(mat)
melted = melt(mat)
ggplot(melted,aes(x=Var2,y=Var1,fill=value)) + geom_tile()

