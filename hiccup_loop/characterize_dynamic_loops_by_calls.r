setwd("../../analysis/hiccup_loops/")

all = read.delim("edgeR/loops_edgeR_test_allStage.txt")
cpb = read.delim("edgeR/loops_cpb.txt")
cpb$max = apply(cpb,1,max)

all$name = paste(all$chr,all$x1,all$x2)
d = all[which(all$fdr<0.001),]
n = all[which(all$fdr>=0.001),]
# read the loop stage information
s = read.delim("loops_merged_across_samples.tab")
s$dynamic = ifelse(s$loopID %in% d$name, "yes","no")
s$distance = s$y1-s$x1
s$max = cpb$max[match(s$loopID,rownames(cpb))]

ggplot(s,aes(x=factor(TotalNumSampleLoopsCalled),y=distance)) + 
  geom_boxplot() + scale_y_log10()

ggplot(s,aes(x=factor(TotalNumSampleLoopsCalled),y=max)) +
  geom_boxplot() #+ scale_y_log10()

#ggplot(s,aes(x=max,y=distance)) + geom_point() + scale_y_log10()


test = s[which(s$TotalNumSampleLoopsCalled==1),]
#ggplot(test,aes(x=factor(Samples),y=distance)) + 
#  geom_boxplot() + scale_y_log10()
#
#ggplot(test,aes(x=factor(Samples),y=max)) +
#  geom_boxplot() #+ scale_y_log10()



