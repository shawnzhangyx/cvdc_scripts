setwd("../../analysis")
name="D00_HiC_Rep1"

peak.list = list()

for (name in readLines("../data/hic/meta/names.txt")){
print(name)
## read in the fithic data.
files = list.files(pattern="txt",path=paste0("fithic/results_2mb/",name,"/q0.01"),full.names=T)
fit.list = list()
for (file in files){
fit.list[[length(fit.list)+1]] = data.frame(fread(file))
}

fit = do.call(rbind, fit.list)
## read in the HICCUPS data. 
hic = data.frame(fread(paste0("hiccup_loops/",name,".loop/enriched_pixels_10000")))
hic$width = hic$y1-hic$x1
hic=hic[which(hic$width<2e6),] 
fit$name = paste(fit$chr1, fit$fragmentMid1,fit$fragmentMid2)
hic$name = paste(hic$chr1, hic$x1,hic$y1)
row = c(nrow(hic),nrow(fit),length(which(hic$name %in% fit$name))/nrow(hic) )
peak.list[[length(peak.list)+1]] = row
}

peak.stat = do.call(rbind,peak.list)
rownames(peak.stat) = readLines("../data/hic/meta/names.txt")
colnames(peak.stat) = c("HICCUP","FitHiC","%HICCUP in FitHiC")

write.csv(peak.stat, "qualityControl/loops/HICCUP.vs.FitHiC.csv")

## HICCUP between replicates
names = readLines("../data/hic/meta/names.txt")

hic.stat.list = list()
for (i in 1:6){
  name1 = names[i*2-1]
  name2 = names[i*2]
  hic1 = data.frame(fread(paste0("hiccup_loops/",name1,".loop/enriched_pixels_10000")))
  hic2 = data.frame(fread(paste0("hiccup_loops/",name2,".loop/enriched_pixels_10000")))
  hic1$name = paste(hic1$chr1, hic1$x1,hic1$y1)
  hic2$name = paste(hic2$chr1, hic2$x1,hic2$y1)
  row = c(nrow(hic1),nrow(hic2),length(which(hic1$name %in% hic2$name))/
    min(c(nrow(hic1),nrow(hic2)) ))
  hic.stat.list[[length(hic.stat.list)+1]] = row
}
hic.stat = do.call(rbind,hic.stat.list) 

rownames(hic.stat) = c("D00","D02","D05","D07","D15","D80")
colnames(hic.stat) = c("Rep1","Rep2","%overlap")
write.csv(hic.stat, "qualityControl/loops/HICCUP.Rep1.vs.Rep2.csv")


fit.stat.list = list()
for (i in 1:6){
  print(i)
  name1 = names[i*2-1]
  name2 = names[i*2]
  files = list.files(pattern="txt",path=paste0("fithic/results_2mb/",name1,"/q0.01"),full.names=T)
  fit.list = list()
  for (file in files){
  fit.list[[length(fit.list)+1]] = data.frame(fread(file))
  }
  fit1 = do.call(rbind, fit.list)

  files = list.files(pattern="txt",path=paste0("fithic/results_2mb/",name2,"/q0.01"),full.names=T)
  fit.list = list()
  for (file in files){
  fit.list[[length(fit.list)+1]] = data.frame(fread(file))
  }
  fit2 = do.call(rbind, fit.list)
  fit1$name = paste(fit1$chr1, fit1$fragmentMid1,fit1$fragmentMid2)
  fit2$name = paste(fit2$chr1, fit2$fragmentMid1,fit2$fragmentMid2)
  row = c(nrow(fit1),nrow(fit2),length(which(fit1$name %in% fit2$name))/
    min(c(nrow(fit1),nrow(fit2)) ))
  fit.stat.list[[length(fit.stat.list)+1]] = row
 }
fit.stat = do.call(rbind,fit.stat.list)

rownames(fit.stat) = c("D00","D02","D05","D07","D15","D80")
colnames(fit.stat) = c("Rep1","Rep2","%overlap")
write.csv(fit.stat, "qualityControl/loops/FitHiC.Rep1.vs.Rep2.csv")


 
