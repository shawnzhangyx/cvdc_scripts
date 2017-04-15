setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/hic/dixonMatrix")
a = data.frame(fread("D00_HiC_Rep1.chr14.norm.txt"))
a = round(a)

rsum = rowSums(a)
INT = 3
p.list = NULL
c.list = NULL
for (i in (INT+1):(dim(a)[1]-INT)){
  print(i)
  c1 = as.numeric( a[i,c(i-INT,i+INT)])
  if (rsum[i] != 0){ 
  c.list = c(c.list,c1)
  p.list = c(p.list,c1/rsum[i])

}
}

plot(density(p.list),xlim=c(0,0.2),ylim=c(0,100))
x=1:10000/10000
lines(x,dbeta(x,14,700),col='red')




### look at the variance
var(c.list)
## 617.9083
median(rsum[rsum!=0])
# 3325
## variance of a binomial.
3325 * (1-14/714)*14/714  # 63.91
## variance of a beta-binomial 
n = 3325; alpha = 14; beta=700
n * alpha * beta * (alpha + beta + n ) / (alpha+beta)**2 / (alpha+beta+1)
# 361

### compare p-values. 
binom.list = NULL
bbinom.list = NULL
for ( i in (INT+1):(dim(a)[1]-INT) ) {
    print(i)
  c1 = as.numeric( a[i,c(i-INT,i+INT)])
  if (rsum[i] != 0){
  binom.list = c(binom.list, 1-pbinom(c1,rsum[i],14/714))
  bbinom.list = c(bbinom.list, 1-pbetabinom(c1,rsum[i],14/714,714))
  }
}

