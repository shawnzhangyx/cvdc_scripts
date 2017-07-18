a=read.delim("atac.read.counts",skip=1)

a[,-c(1:6)] = sweep(a[,-c(1:6)],2,colSums(a[,-c(1:6)]),"/")*1e6

ggplot(a, aes( x=bam.D0_1.dedup.bam,y=bam.D0_2.dedup.bam)) + geom_point() + 
  geom_abline(slope=1,color="red") + geom_density_2d() +
  scale_y_log10() + scale_x_log10()

ggplot(a, aes( x=bam.D0_1.sorted.bam,y=bam.D0_2.sorted.bam)) + geom_point() +
  geom_abline(slope=1,color="red") + geom_density_2d() +
  scale_y_log10() + scale_x_log10()

ggplot(a, aes( x=bam.D80_1.dedup.bam,y=bam.D80_2.dedup.bam)) + geom_point() +
  geom_abline(slope=1,color="red") + geom_density_2d() +
  scale_y_log10() + scale_x_log10()

ggplot(a, aes( x=bam.D80_1.dedup.bam,y=bam.D80b_1.dedup.bam)) + geom_point() +
  geom_abline(slope=1,color="red") + geom_density_2d() +
  scale_y_log10() + scale_x_log10()

ggplot(a, aes( x=bam.D80_2.dedup.bam,y=bam.D80b_1.dedup.bam)) + geom_point() +
  geom_abline(slope=1,color="red") + geom_density_2d() +
  scale_y_log10() + scale_x_log10()


ggplot(a, aes( x=bam.D80_1.sorted.bam,y=bam.D80_2.sorted.bam)) + geom_point() +
  geom_abline(slope=1,color="red") + geom_density_2d() +
  scale_y_log10() + scale_x_log10()

test1 = a[,-c(1:6)]
pca1 = prcomp(t(test1))

plot(pca1$x[,1],pca1$x[,2],type='n')
text(pca1$x[,1],pca1$x[,2],rownames(pca1$x))

test2 = test1[,seq(1,32,2)]
pca2 = prcomp(t(test2))
plot(pca2$x[,1],pca2$x[,2],type='n')
text(pca2$x[,1],pca2$x[,2],rownames(pca2$x))

test3 = test1[,seq(2,32,2)]
pca3 = prcomp(t(test3))
plot(pca3$x[,1],pca3$x[,2],type='n')
text(pca3$x[,1],pca3$x[,2],rownames(pca3$x))

