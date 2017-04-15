setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/fithic/results")
#r1 = data.frame(fread(paste0("zcat ","D00_HiC_Rep1/14.spline_pass2.significances.txt.gz")))
#r2 = data.frame(fread(paste0("zcat ","D00_HiC_Rep2/14.spline_pass2.significances.txt.gz")))
r1 = data.frame(fread(paste0("zcat ","D00_HiC_Rep1/14.norm.spline_pass2.significances.txt.gz")))
r2 = data.frame(fread(paste0("zcat ","D00_HiC_Rep2/14.norm.spline_pass2.significances.txt.gz")))
r1$name = paste(r1$fragmentMid1, r1$fragmentMid2)
r2$name = paste(r2$fragmentMid1, r2$fragmentMid2)

name = r1$name[which(r1$name %in% r2$name)]
q1 = r1$q.value[match(name,r1$name)]
q2 = r2$q.value[match(name,r2$name)]
comb = data.frame(name,q1,q2)

comb$r1 = rank(comb$q1)
comb$r2= rank (comb$q2)

top = comb[which(comb$r1<10000 | comb$r2<10000),]
plot(top$r1,top$r2)
plot(-log10(top$q1),-log10(top$q2))

