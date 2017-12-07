setwd("../../analysis/ab_compartments/")
data = read.delim("pc1_data/combined.matrix",header=F)

mat = data[,-(1:3)]
rownames(mat) = paste(data$V1,data$V2,data$V3)
mat = ifelse(mat>0,1,-1)
mat = (mat[,seq(1,12,2)] +mat[,seq(2,12,2)])/2
replicated = apply(mat,1,prod)

mat.rep = mat[which(replicated!=0),]
colnames(mat.rep) = c("D00","D02","D05","D07","D15","D80")
mat.rep = as.data.frame(mat.rep)
#mat.rep = mat.rep[order(rowSums(mat.rep),mat.rep$D00,mat.rep$D02,mat.rep$D05,mat.rep$D07,mat.rep$D15, mat.rep$D80),]
mat.rep = mat.rep[order(mat.rep$D00,mat.rep$D02,mat.rep$D05,mat.rep$D07,mat.rep$D15, mat.rep$D80),]
#mat.rep.m = melt(as.matrix(mat.rep))


calSwitches = function(vec){
  num = length(which(vec[-6]*vec[-1] == -1))
}

switches = apply(mat.rep,1,calSwitches)

mat.rep$switches = switches

mat.rep$type = ifelse(mat.rep$D00==1, "A","B")
mat.rep$type[which(mat.rep$switches==1)] = paste0(mat.rep$type[which(mat.rep$switches==1)],"1")
mat.rep$type[which(mat.rep$switches==2)] = paste0(mat.rep$type[which(mat.rep$switches==2)],"2")
mat.rep$type[which(mat.rep$switches==3)] = paste0(mat.rep$type[which(mat.rep$switches==3)],"3")
mat.rep$type[which(mat.rep$switches==4)] = paste0(mat.rep$type[which(mat.rep$switches==4)],"4")

mat.rep$type2 = mat.rep$type
mat.rep$type2[which(mat.rep$type == "A1")] = "AB"
mat.rep$type2[which(mat.rep$type == "B1")] = "BA"
mat.rep$type2[which(mat.rep$type == "A2")] = "ABA"
mat.rep$type2[which(mat.rep$type == "B2")] = "BAB"
mat.rep$type2[which(mat.rep$type == "A3")] = "AB"
mat.rep$type2[which(mat.rep$type == "B3")] = "BA"
mat.rep$type2[which(mat.rep$type == "A4")] = "ABA"
mat.rep$type2[which(mat.rep$type == "B4")] = "BAB"


out = cbind(rownames(mat.rep),mat.rep)
out[,1] = gsub(" ","\t",out[,1])

write.table(out[,c(1,8,10)], "compartmentSwitch/switchType.bed", row.names=F,col.names=F,quote=F,sep='\t')

