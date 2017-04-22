setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/counts")

a=data.frame(fread("atac.frag.counts",skip=1))
width = a$End-a$Start
counts = a[,-c(1:6)]
rpm = sweep(counts,2,colSums(counts),'/')*1e6
rpkm = sweep(rpm,1,width,'/')*1e3

write.table(cbind(a[,c(1:6)],rpkm),"atac.fpkm",row.names=F,quote=F,sep='\t')

