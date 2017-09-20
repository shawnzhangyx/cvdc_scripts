input = commandArgs(trailing=T)
# = args[1]
#a=data.frame(fread("chr3.d00.rep1.txt"))
a=data.frame(fread(input))

a =a[which(a$dist>10000 & a$p_local_b2r<0.01),]
a=a[order(a$x,a$y),]
a$close1=0
for(i in 1:(nrow(a)-1)){
a$close1[i] =  a[i+1,1]==a[i,1] & a[i+1,2]-a[i,2] == 10000
}
a=a[order(a$y,a$x),]
a$close2=0
for(i in 1:(nrow(a)-1)){
a$close2[i] =  a[i+1,1]-a[i,1] == 10000 & a[i+1,2] == a[i,2] 
}


a$close1b = c(0,a$close1[-nrow(a)]) | a$close1
a$close2b = c(0,a$close2[-nrow(a)]) | a$close2

b= a[which(a$close1b == 1| a$close2b==1),]
out = b[which(b$p_local_b2r<1e-5),]


#write.table(out,"chr3.d00.rep1.enriched.txt",row.names=F,sep='\t',quote=F)
write.table(out,paste0(input,".removed"),row.names=F,sep='\t',quote=F)

