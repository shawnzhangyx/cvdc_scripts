setwd("../../analysis/ab_comparments")

con.list = list()
for (stage in c("D00","D02","D05","D07","D15","D80")){
  for (rep in c("1","2")){
  print(c(stage,rep))
  
  ab = data.frame(fread(list.files(path="pc1_data",pattern=paste0(stage,"_",rep),full.names=T)))
  ab = ab[which(ab$V1=="chr1"),]
  con = data.frame(fread(paste0("../../data/hic/matrix_raw/",stage,"_HiC_Rep",rep,"/chr1_50k.txt")))

  con$a1 = ifelse(ab$V4>0,"A","B")[match(con$V1,ab$V2)]
  con$a2 = ifelse(ab$V4>0,"A","B")[match(con$V2,ab$V2)]
  con$distance = con$V2-con$V1
  # remove NA
  con.rm = con[-which(is.na(con$a1) | is.na(con$a2)),]
  con.rm$type = ifelse(con.rm$a1=="A",ifelse(con.rm$a2=="A","AA","AB"),
      ifelse(con.rm$a2=="A","AB","BB"))

  agg = aggregate(V3~distance+type,con.rm, sum)
  agg$name = paste(stage,rep,sep="_")
  agg$ratio = agg$V3/sum(agg$V3)
  con.list[[length(con.list)+1]] = agg
}
}

#  ggplot(agg, aes(x=distance,color=type,y=ratio)) + geom_line() +
#  scale_y_log10() +
#  scale_x_log10()

combined = do.call(rbind, con.list)

ggplot(combined, aes(x=distance, color=substr(name,1,3),y=ratio)) + 
  geom_point(size=0.1)+
#  geom_smooth(span=0.01) + 
  scale_y_log10() +
#  scale_x_log10() +
  facet_wrap(~type)




