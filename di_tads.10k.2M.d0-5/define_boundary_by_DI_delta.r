setwd("../../analysis/di_tads.10k.2M.d0-5")

#library(preprocessCore)

a = read.csv("boundary_DI_overlaps/boundary.DI_delta.csv",stringsAsFactors=F)
a = a[-which( rowSums(a[,seq(2,13,2)]<2)>0),]

#qtl = normalize.quantiles(as.matrix(a[,seq(3,25,2)]))
qtl = a[,seq(3,13,2)]

#quantile normalize and transform negative to zero. 
a2 = data.frame(a$name,qtl)
colnames(a2) = colnames(a)[c(1,seq(3,13,2))]
a2$max = apply(a2[,2:7],1,max)


b = read.delim("boundaries/combined_boundary.uniq.txt",header=F)
b$name = paste0(b$V1,":",b$V2)
b = b[match(a2$name,b$name),]
b$D00 = grepl("D00",b$V3)
b$D02 = grepl("D02",b$V3)
b$D05 = grepl("D05",b$V3)

true = as.numeric(unlist(a2[,c(2:7)])[unlist(b[,rep(6:8,each=2)])])

false = as.numeric( unlist(a2[,c(2:7)])[unlist(!b[,rep(6:8,each=2)])])

dat = data.frame(c(true,false),c(rep("true",length(true)),rep("false",length(false))))
colnames(dat) =c("value","type")

# set the cutoff for tad boundaries. 
CUTOFF = 200
for (CUTOFF in c(100,150,200,250,300)){
print(CUTOFF)
# number of boundaries passing the cut-off. 
bd = a2[which(a2$max>=CUTOFF),]
bd$chr=sub("(chr.*):(.*)","\\1",bd$name)
bd$loc=as.numeric(sub("(chr.*):(.*)","\\2",bd$name))
bd = bd[,c(9,10,8,2:7)]
bd = bd[order(-bd$max),]

colnames(bd)[1:3] = c("chr1","x1","score")

combined = list()
while ( nrow(bd)>0){
tad = bd[1,]
#x1 = ifelse(bd$x1
idx = which(  bd$chr1 == tad$chr1 & abs(bd$x1-tad$x1)<=50000 )
#tad$samples = paste(sort(sub("(.{12}).*.TAD.bed","\\1",bd[idx,"sample"])),collapse=",")
len = length(combined)
print(len)
combined[[len+1]] = tad
bd = bd[-idx,]
}

tads = do.call(rbind,combined)
write.csv(tads,paste0("boundaries/combined_boundary.DI_cutoff.",CUTOFF,".csv"))
}


