setwd("../../analysis/tads")
library(stringr)

a= read.delim("combined_tads.uniq.gt1.txt")
# remove unreplicated tads. 
#a = a[which(a$num_rep>1),]

a$D00 = grepl("D00",a$samples)
a$D02 = grepl("D02",a$samples)
a$D05 = grepl("D05",a$samples)
a$D07 = grepl("D07",a$samples)
a$D15 = grepl("D15",a$samples)
a$D80 = grepl("D80",a$samples)
a$num_stages = rowSums(a[,16:21])
a$name = paste(a$chr1,a$x1,a$x2)

a$name = paste(a$chr1,a$x1,a$x2)
#c=read.delim("combined_tads.uniq.oe_mean.txt")
c = read.delim("combined_tads.uniq.oe_upper_triangle_mean.txt")
c$name = paste(c$chr,c$x1,c$x2)
c=c[match(a$name,c$name),]

mat = a[,rep(16:21,each=2)]
#peak_oe = unlist(c[,4:15]*mat)
oe = unlist(c[,4:15])
cut_off_ratio  = sum(unlist(mat))/nrow(mat)/ncol(mat)
cut_off = quantile(oe,1-cut_off_ratio)
peak_oe = c[,4:15]>cut_off
#rownames(peak_oe) = c$name
peak_rep = cbind(c[,-16],peak_oe)[which(rowSums(peak_oe)>0),]

peak_rep2 = cbind(peak_rep[,1:15],peak_rep[,seq(16,27,2)]+peak_rep[,seq(17,27,2)] > 0)
peak_dyn = peak_rep2[which(rowSums(peak_rep2[,16:21])<6),]

#construct_mat = function()
  d1=1
  design = list()
#  for (d1 in 0:1){
    for (d2 in 0:1){
      for (d3 in 0:1){
        for (d4 in 0:1){
          for (d5 in 0:1){
            for (d6 in 0:1){
              design[[length(design)+1]] = rep(c(d1,d2,d3,d4,d5,d6),each=2)
            }}}}}
  design = do.call(rbind,design)[-length(design),]
  
calc_state = function(vec,design){
     logFC = log( 
     rowSums(sweep(design,2,as.numeric(vec),FUN='*'))/rowSums(design)/ 
     ( rowSums(sweep(1-design,2,as.numeric(vec),FUN='*'))/rowSums(1-design) ) )
      idx = which.max(abs(logFC))
     if ( logFC[idx]>0 ) { out=c(design[idx,],logFC[idx]) } else 
      { out=c( (1-design)[idx,],logFC[idx])  }
     }

library(doParallel)
registerDoParallel(cores=8)
diffTest = foreach(i=1:nrow(peak_dyn) ) %dopar% {
print(i)
calc_state(peak_dyn[i,4:15],design)
}
diffTest = do.call(rbind,diffTest)

FC = unlist(abs(log(peak_rep2[,seq(4,15,2)]/peak_rep2[,seq(5,15,2)])))

peak_dyn2 = cbind(peak_dyn, diffTest[,seq(1,13,2)])
peak_dyn3 = peak_dyn2[which(abs(peak_dyn2[,28])>log(1.5)),]
peak_nondyn3 = peak_dyn2[which(abs(peak_dyn2[,28])<=log(1.5)),]
peak_nondyn3[,16:21]=TRUE
peak_final = rbind(peak_rep2[which(rowSums(peak_rep2[,16:21])==6),c(1:3,16:21)],
    peak_nondyn3[,c(1:3,16:21)],peak_dyn3[,c(1:3,16:21)])

colnames(peak_dyn3)[c(16:21)]=c("D00","D02","D05","D07","D15","D80")
write.table(peak_final, "combined_tads.uniq.final.txt",row.names=F,quote=F,sep='\t')
write.table(peak_dyn3,"dynamic_tads.txt",row.names=F,quote=F,sep="\t")

#mat = peak_dyn3[,c(16:21)]
mat
mat = mat[order(mat$D00,mat$D02,mat$D05,mat$D07,mat$D15,mat$D80),]
rownames(mat) = 1:nrow(mat)
melted = melt(as.matrix(mat))
ggplot(melted,aes(x=Var2,y=Var1,fill=value)) + geom_tile()

