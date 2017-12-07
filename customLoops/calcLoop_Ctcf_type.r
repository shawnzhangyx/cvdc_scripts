
loops=read.delim("loops/loops.cpb.logFC.edger.final.cluster.txt")
loops$a1 = sub("(.*) (.*) (.*)","\\1 \\2",loops$name)
loops$a2 = sub("(.*) (.*) (.*)","\\1 \\3",loops$name)

ctcf = data.frame(fread("overlap_anchors_to_features/anchor.CTCF_merged_peaks.txt"))
ctcf$anchor = paste(ctcf$V1,ctcf$V2+10000)

orient = data.frame(fread("../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.motif_orientation.relaxed.txt"))
ctcf$orient = orient$V6[match(ctcf$V7,orient$V4)]

agg = aggregate(orient~anchor,ctcf, function(vec){paste(sort(unique(vec)),collapse=",")})


loops$o1 = agg$orient[match(loops$a1,agg$anchor)]
loops$o2 = agg$orient[match(loops$a2,agg$anchor)]

loops$type = "NO-CTCF"
loops$type[which( loops$o1=="Unknown" | loops$o2 == "Unknown")] = "Unknown"
loops$type[which( loops$o1!="Unknown" & loops$o2 != "Unknown")] = "Incorrect"

loops$type[which( grepl("+",loops$o1) & grepl("-",loops$o2))] = "Inward"
#loops$type[which( grepl("+",loops$o1) & grepl("-",loops$o2))] = "Inward"

tab =  table(loops$type,loops$cluster)

melted = melt(tab)
melted$Var1 = factor(melted$Var1, levels=rev(c("Inward","Incorrect","Unknown","NO-CTCF")))

pdf("figures/loop_cluster_CTCF_type.pdf",height=5,width=5)
ggplot(melted,aes(x=Var2,fill=Var1,y=value)) + 
    geom_bar(stat="identity",position="fill") +
    scale_fill_brewer(palette="Blues") +
    theme_bw()
dev.off()

