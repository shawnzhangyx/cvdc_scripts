setwd("../../analysis/fithic/")
system("mkdir promoter_enhancer_interaction")
anchor = 2388* 10**4

out.list= list()
for (name in readLines("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/hic/meta/names.txt")){
print(name)
data = data.frame(fread(paste0("zcat results/",name,"/14.norm.spline_pass2.significances.txt.gz")))

matched = data[which(data$fragmentMid1 == anchor | data$fragmentMid2 == anchor),]
sig = matched[which(matched$q.value<0.01 & matched$contactCount> 10),]
sig$partner = ifelse (sig$fragmentMid1 == anchor, sig$fragmentMid2, sig$fragmentMid1)
out = cbind(name,sig[,c(1,8,5,7)])
out.list[[name]] = out
}
out.tab = do.call(rbind,out.list)

write.csv(out.tab,paste0("promoter_enhancer_interaction/",anchor,".txt"))

ggplot(out.tab, aes(x=partner,y=name,fill=-log10(q.value)))+geom_tile() + 
scale_fill_gradient(low='blue',high='red') + xlim(2.3e7,2.4e7)

ggplot(out.tab, aes(x=partner,y=name,fill=contactCount))+geom_tile() +
scale_fill_gradient(low='blue',high='red') + xlim(2.3e7,2.4e7)


