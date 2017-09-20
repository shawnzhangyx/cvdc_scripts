setwd("../../analysis/tads")
library(stringr)

a= read.delim("combined_tads.uniq.txt")
# remove unreplicated tads. 
#a = a[which(a$num_rep>1),]

#a$D00 = grepl("D00",a$sample)
#a$D02 = grepl("D02",a$sample)
#a$D05 = grepl("D05",a$sample)
#a$D07 = grepl("D07",a$sample)
#a$D15 = grepl("D15",a$sample)
#a$D80 = grepl("D80",a$sample)
#a$num_stages = rowSums(a[,9:14])

a$D00 = grepl("D00.Rep1",a$sample) & grepl("D00.Rep2",a$sample)
a$D02 = grepl("D02.Rep1",a$sample) & grepl("D02.Rep2",a$sample)
a$D05 = grepl("D05.Rep1",a$sample) & grepl("D05.Rep2",a$sample)
a$D07 = grepl("D07.Rep1",a$sample) & grepl("D07.Rep2",a$sample)
a$D15 = grepl("D15.Rep1",a$sample) & grepl("D15.Rep2",a$sample)
a$D80 = grepl("D80.Rep1",a$sample) & grepl("D80.Rep2",a$sample)
a$num_stages = rowSums(a[,9:14])
a = a[which(a$num_stages>0),]
a$name = paste(a$chr1,a$x1,a$x2)
#b=read.delim("edgeR/tads_edgeR_test_allStage.txt")
#c=read.delim("edgeR/tad_cpb.txt")
c=read.delim("combined_tads.uniq.oe_mean.txt")
c$name = paste(c$chr,c$x1,c$x2)
c=c[match(a$name,c$name),]
#clog = log(c)
clog = c[,-c(1:3)]

t.out = sapply(1:nrow(c),function(i){ if (a$num_stages[i]==6) { 1}
 else { t.test(as.numeric( clog[i,rep(which(a[i,9:14]==1),each=2)*2+c(-1,0)]), 
        as.numeric( clog[i,rep(which(a[i,9:14]==0),each=2)*2+c(-1,0)]) )$p.value
 }  })

out = cbind(a[,c(1:3,9:16)],clog,t.out)
out$chr1 = paste0("chr",out$chr1)
out = out[order(out$t.out),]


