setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/fithic/results")
a = read.delim("D00_HiC_Rep1/14.fithic_pass2.txt")
b = read.delim("D00_HiC_Rep2/14.fithic_pass2.txt")

cols = rainbow(14)
files = list.files(pattern="pass2.txt",recursive=T)
for ( file in files){
  a= read.delim(file)
  if (file == files[1]){
p = ggplot(a,aes(x=avgGenomicDist,y=contactProbability))+geom_line() +  xlim(1,5e5)
  n = 1
  } else {
  p = p + geom_line(data=a,aes(x=avgGenomicDist,y=contactProbability),col=cols[n])
  n = n + 1 
  }
}
p
