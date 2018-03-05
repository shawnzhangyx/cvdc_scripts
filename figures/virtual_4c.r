args = commandArgs()

DIST=2e6

chr = args[1]
loc = args[2]
start = args[3]
end = args[4]
name = args[5]

out = list()
sample = "D00_HiC_Rep1"
for (sample in c("D00_HiC_Rep1","D00_HiC_Rep2","D02_HiC_Rep1","D02_HiC_Rep2","D05_HiC_Rep1","D05_HiC_Rep2","D07_HiC_Rep1","D07_HiC_Rep2","D15_HiC_Rep1","D15_HiC_Rep2","D80_HiC_Rep1","D80_HiC_Rep2") ){
  print(sample)
  mat = data.frame(fread(paste0("../../data/hic/matrix/",sample,"/",chr,"_10000.txt")))
  sli = mat[which(mat$V1==loc | mat$V2 == loc),]
  sli$pos = ifelse(sli$V1==loc, sli$V2, sli$V1)
  sli$norm = sli$V3/sum(sli$V3)*1e6
  sli = sli[which(sli$pos > start & sli$pos< end ),]
  sli$sample= sample
out[[sample]] = sli
}

out2 = do.call(rbind, out)

ggplot(out2) + geom_line(aes(x=pos,y=norm,color=sample))

