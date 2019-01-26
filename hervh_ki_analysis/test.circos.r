options(stringsAsFactors = FALSE);
library(OmicCircos);
set.seed(1234);

## initial values for simulation data 
seg.num     <- 10;
ind.num     <- 20;
seg.po      <- c(20:50);
link.num    <- 10;
link.pg.num <- 4;
## output simulation data
sim.out <- sim.circos(seg=seg.num, po=seg.po, ind=ind.num, link=link.num, 
  link.pg=link.pg.num);

  seg.f     <- sim.out$seg.frame;
  seg.v     <- sim.out$seg.mapping;
  link.v    <- sim.out$seg.link
  link.pg.v <- sim.out$seg.link.pg
  seg.num   <- length(unique(seg.f[,1]));

  ## select segments
  seg.name <- paste("chr", 1:seg.num, sep="");
  db       <- segAnglePo(seg.f, seg=seg.name);

  colors   <- rainbow(seg.num, alpha=0.5);


  ###################################################
  ### code chunk number 13: OmicCircos4vignette2
  ###################################################
  par(mar=c(0, 0, 0, 0));

  plot(c(1,800), c(1,800), type="n", axes=FALSE, xlab="", ylab="", main="");

  circos(R=400, type="chr", cir=db, col=colors, print.chr.lab=TRUE, W=4, scale=TRUE);
  circos(R=360, cir=db, W=40, mapping=seg.v, col.v=8, type="box",   B=TRUE, col=colors[1], lwd=0.1, scale=TRUE);

