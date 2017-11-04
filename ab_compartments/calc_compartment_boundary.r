a=data.frame(fread("combined.matrix"))
a=a[order(a$V1,a$V2),]

computeSwitch = function(vec){
  length(which(vec*c(vec[-1],vec[1]) <0))
  }


