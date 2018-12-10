extend the regions to 20kb 
awk -v OFS="\t" '{print $1,$2-20000,$3+20000,$4}' hervh.sorted_rnaseq.name.bed > evolution_analysis/hervh.sorted_rnaseq.name.ext20k.bed


# lift to mouse mm10
~/software/ucsc/liftOver evolution_analysis/hervh.sorted_rnaseq.name.ext20k.bed ~/software/ucsc/hg19ToMm10.over.chain.gz evolution_analysis/mouse/HERVH-int.liftover.Mm10.txt evolution_analysis/mouse/HERVH-int.liftover.Mm10.txt.unmapped -minMatch=0.1

# lift to chimp Pantro6
~/software/ucsc/liftOver evolution_analysis/hervh.sorted_rnaseq.name.ext20k.bed ~/software/ucsc/hg19ToHg38.over.chain.gz evolution_analysis/HERVH-int.liftover.Hg38.ext20k.txt evolution_analysis/HERVH-int.liftover.Hg38.ext20k.txt.unmapped -minMatch=0.95

~/software/ucsc/liftOver evolution_analysis/HERVH-int.liftover.Hg38.ext20k.txt ~/software/ucsc/hg38ToPanTro6.over.chain.gz evolution_analysis/chimp/HERVH-int.liftover.Pantro6.txt evolution_analysis/chimp/HERVH-int.liftover.Pantro6.txt.unmapped -minMatch=0.1

# lift to marmoset caljac3
~/software/ucsc/liftOver evolution_analysis/hervh.sorted_rnaseq.name.ext20k.bed ~/software/ucsc/hg19ToCalJac3.over.chain.gz evolution_analysis/marmoset/HERVH-int.liftover.CalJac3.txt evolution_analysis/marmoset/HERVH-int.liftover.CalJac3.txt.unmapped -minMatch=0.1



