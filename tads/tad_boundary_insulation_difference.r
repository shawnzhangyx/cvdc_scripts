setwd("../../analysis/tads/")

b = read.delim("tad_calls/TAD_boundary_across_stages.tab",stringsAsFactors=F)
ins = read.delim("insulation_data/combined.matrix",stringsAsFactors=F)
ins = ins[order(ins$chrom,ins$start),]

row.list = list()
for (idx in 1:nrow(b)){
print(idx)
bin_idx = which(ins$chrom==b$chr[idx] & ins$start < b$pos[idx] & ins$end >= b$pos[idx])[1]
if ( length(which(!is.na(bin_idx))) <1) next 
row = ins[which(ins$chrom==b$chr[idx] & ins$start < b$pos[idx] & ins$end >= b$pos[idx]),]
row.list[[length(row.list)+1]] = row
}

tab = do.call(rbind,row.list)
tab$name = paste(tab$chrom,tab$start,tab$end)
tab$name = factor(tab$name,levels=tab$name)
tab.f = tab[,-c(1:3)]

write.table(tab.f[,c(13,1:12)],"tad_boundary_changes/tad_boundary_insulation_score.txt",row.names=F,sep="\t",quote=F)


group = factor(c("D00","D00","D02","D02","D05","D05","D07","D07","D15","D15","D80","D80"))

results =sapply(1:nrow(tab.f) ,function(x){ summary(aov(as.numeric(tab.f[x,-13])~group))[[1]][["Pr(>F)"]]} )
#summary(tab.f[,2]-tab.f[,1])
#summary(tab.f[,3]-tab.f[,1])
diff = as.vector(unlist(tab.f[,seq(2,12,2)]-tab.f[,seq(1,12,2)]))
quantile(abs(diff),c(0.95,0.99))
#       95%       99%
# 0.1530712 0.2449922
ave = (tab.f[,seq(2,12,2)]+tab.f[,seq(1,12,2)])/2
change = ave[,-1]-ave[,-6]

