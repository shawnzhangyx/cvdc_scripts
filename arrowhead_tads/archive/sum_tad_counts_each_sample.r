setwd("../../analysis/tads")
name= commandArgs(trailing=T)[1]
outname= commandArgs(trailing=T)[2]

df = data.frame(fread(name,blank.lines.skip=T))
#out = aggregate(contacts~chr+x1+x2,df,FUN=sum)
out = aggregate(contacts~chr+x1+x2,df,FUN=median)
write.table(out,outname,row.names=F,quote=F,sep='\t')
