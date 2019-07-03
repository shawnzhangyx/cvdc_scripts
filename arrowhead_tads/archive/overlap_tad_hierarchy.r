a=read.delim("tad_hierarchy/tads_to_tads_overlap.txt",header=F)
#calculate TAD width
a$inner_width = a$V3-a$V2
a$outer_width = a$V6-a$V5
a$name = paste(a$V1,a$V2,a$V3)

# remove ones that self-overlap
b1 = a[which(a$V2==a$V5 & a$V3 ==a$V6),]
b2 = a[-which(a$V2==a$V5 & a$V3 ==a$V6),]
# remove ones that are greater than 1. 
b2 = b2[which(b2$inner_width< b2$outer_width *0.8),]
d = b2[!duplicated(b2[,1:3]),]

d00 = read.delim("stage_specific_tads/D00.unique.tads",header=F)
d00$name = paste(d00$V1,d00$V2,d00$V3)

table(d00$name %in% d$name)

