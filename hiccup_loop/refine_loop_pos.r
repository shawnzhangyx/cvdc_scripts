a=read.delim("combined_loops.hiccup_refined.txt")

files= list.files(pattern="30k.txt",path="contacts_by_samples",full.names=T,recursive=T)
names = sub("contacts_by_samples/(D.._HiC_Rep.).contacts.30k.txt","\\1",files)

dat = list()
for (i in 1:12){
  dat[[i]] = data.frame(fread(files[[i]]))
  }

datm = Reduce(function(...)merge(...,by=c("chr","x1","y1","x2","y2"),all.x=T),dat)

a = a[,c(1,2,3,16:27)]

m = merge(datm,a,by=c("chr","x1","y1"))
# only use the contacts from true peak calls.
valid_contacts = m[,c(6:17)]*m[,c(18:29)]

mat = cbind(m[,1:5],rowSums(valid_contacts))
colnames(mat)[6] = "contacts"
mat$name = paste(mat$chr,mat$x1,mat$y1)

uniqnames = unique(mat$name)

mat$dist = mat$y2-mat$x2
mat = mat[order(mat$name,-mat$dist),]
mat$rank=1
#tab=list()
num=0
for (name in uniqnames){
#  tmp = mat[which(mat$name==name),]
#  tab[[name]] = tmp[which.max(tmp$contacts),]
mat$rank[which(mat$name == name)] = rank(-mat$contacts[which(mat$name== name)],
  ties.method="first")
num = num + 1
if (num %% 100 ==1 ) { print(num) }
}

mat.top = mat[which(mat$rank==1),]
write.table(mat.top,"uniq_loops.details.txt",row.names=F,quote=F,sep='\t')

write.table(mat.top[,c(1,4,5)],"uniq_loops.final.txt",row.names=F,quote=F,sep='\t',col.names=F)

#tab1 = do.call(rbind,tab)



