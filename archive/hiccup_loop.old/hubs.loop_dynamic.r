setwd("../../analysis/hiccup_loops")
hub = read.delim("hubs/loops.hub.txt")
loop = read.delim("loops.cpb.logFC.edger.dynamic.cluster.txt")
hub$cluster = loop$cluster[match(hub$loopID, loop$name)]
hub$cluster[is.na(hub$cluster)] = 0
hub$yes = 1
cluster = aggregate(cluster~hub,data=hub,function(vec){paste(sort(vec),sep=',')})[-1,]
count = aggregate(cbind(yes,cluster)~hub, data=hub, function(vec){sum(vec>0,na.rm=T)})
#count = dcast(hub, function(vec){sum(vec>0,na.rm=T)})
start = aggregate(x1~hub,data=hub,min)
end = aggregate(y2~hub,data=hub,max)
chr = aggregate(chr1~hub, data=hub,function(vec){paste(unique(as.character(vec)),collapse=',')})
combined = Reduce(function(...)merge(...,by="hub",all.x=T),list(count,cluster,chr,start,end))
combined$distance = combined$y2-combined$x1
combined$dyn_ratio = combined$cluster.x/combined$yes
