setwd("../../analysis/tads/tad_calls/")
options(scipen=99)
files=list.files(pattern="TAD.txt")

b.list = list()
for (file in files){
  data = read.delim(file,header=F)
  data$stage = file
  b.list[[length(b.list)+1]] = data
  }

b = do.call(rbind,b.list)
b = b[order(b$V1,b$V2,b$stage),]

chr = b[1,1]
start = b[1,2]
adjusted.pos = NULL
for (i in 1:nrow(b)){
    if (b[i,1] == chr & b[i,2]-start <= 100000) {
        }
    else {
        chr = b[i,1]
        start = b[i,2]
        }
        adjusted.pos[i] = start 
}

b$pos = adjusted.pos
b$loc = paste(b$V1,b$pos)
b$count = table(b$loc)[match(b$loc,names(table(b$loc)))]
b = b[order(b$stage),]
tab =table(table(b$loc))
#   1    2    3    4    5    6
#   1150  754  614  547  708 1895


#t = dcast(V1+pos~stage,fun.aggregate=length, data=b)
t=reshape(data=b,idvar=c("V1","pos"),timevar="stage",direction="wide",drop=c("V2","loc"))
t[,3:8] = ifelse(is.na(t[,3:8]),0,1)
t$total = rowSums(t[,3:8])
t.sorted = t[do.call(order,-t[,c(9,3:8)]),]
colnames(t.sorted)[1] = "chr"
write.table(t.sorted,"TAD_boundary_across_stages.tab",row.names=F,sep='\t',quote=F)
loc = paste(t.sorted$chr,t.sorted$pos)

#b = b[order(-b$count,b$stage),]
#b$loc = factor(b$loc,levels=unique(b$loc))
b$loc = factor(b$loc,levels=loc)
b$count = factor(b$count)

pdf("tad_changes_across_stages.pdf",height=20,width=5)
ggplot(b, aes(x=stage,y=loc,fill=count)) + geom_tile()+
#  facet_wrap(~count,ncol=6) +
  theme (
    axis.text.x = element_text(angle=90,vjust=0.5),
    axis.text.y = element_blank()
    )
dev.off()

