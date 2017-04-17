setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/ab_compartments/")
data = read.delim("pc1_data/combined.matrix",header=F)

mat = data[,-(1:3)]
mat = ifelse(mat>0,1,0)

switch = sapply(2:ncol(mat)-1, function(x){ table (mat[,x+1]-mat[,x]) })
rownames(switch) = c("AtoB","NoChange","BtoA")
colnames(switch) = c("D0-D2","D2-D5","D5-D7","D7-D15","D15-D80")
switch = sweep(switch,2,colSums(switch),'/')
switch.c = switch[-2,]*100

melted = melt(switch.c,id.var=rownames(switch.c))

p = ggplot(melted,aes(x=Var2,y=Var1,fill=value)) + geom_tile()+ 
    scale_fill_gradient2(mid="white",high='red')

write.table(switch.c,"compartmentSwitch/switchRatioBetweenStage.txt",sep='\t',quote=F)

