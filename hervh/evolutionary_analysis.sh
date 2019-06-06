cd ../../analysis/hervh/
# extend the regions to 20kb 
awk -v OFS="\t" '{print $1,$2-20000,$3+20000,$4}' hervh.sorted_rnaseq.name.bed > evolution_analysis/hervh.sorted_rnaseq.name.ext20k.bed


# lift to mouse mm10
~/software/ucsc/liftOver evolution_analysis/hervh.sorted_rnaseq.name.ext20k.bed ~/software/ucsc/hg19ToMm10.over.chain.gz evolution_analysis/mouse/HERVH-int.liftover.Mm10.txt evolution_analysis/mouse/HERVH-int.liftover.Mm10.txt.unmapped -minMatch=0.1

# lift to chimp Pantro6
~/software/ucsc/liftOver evolution_analysis/hervh.sorted_rnaseq.name.ext20k.bed ~/software/ucsc/hg19ToHg38.over.chain.gz evolution_analysis/HERVH-int.liftover.Hg38.ext20k.txt evolution_analysis/HERVH-int.liftover.Hg38.ext20k.txt.unmapped -minMatch=0.95

~/software/ucsc/liftOver evolution_analysis/HERVH-int.liftover.Hg38.ext20k.txt ~/software/ucsc/hg38ToPanTro6.over.chain.gz evolution_analysis/chimp/HERVH-int.liftover.Pantro6.txt evolution_analysis/chimp/HERVH-int.liftover.Pantro6.txt.unmapped -minMatch=0.1

# lift to bonobo PanPan2
~/software/ucsc/liftOver evolution_analysis/HERVH-int.liftover.Hg38.ext20k.txt ~/software/ucsc/hg38ToPanPan2.over.chain.gz evolution_analysis/bonobo/HERVH-int.liftover.PanPan2.txt evolution_analysis/bonobo/HERVH-int.liftover.PanPan2.txt.unmapped -minMatch=0.1

# lift to marmoset caljac3
~/software/ucsc/liftOver evolution_analysis/hervh.sorted_rnaseq.name.ext20k.bed ~/software/ucsc/hg19ToCalJac3.over.chain.gz evolution_analysis/marmoset/HERVH-int.liftover.CalJac3.txt evolution_analysis/marmoset/HERVH-int.liftover.CalJac3.txt.unmapped -minMatch=0.1


### overlap HERVH with DI. 
# human
intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$1":"$2"-"$3 } else {print $1,$2-400000,$3+400000,$4 }}' evolution_analysis/hervh.sorted_rnaseq.name.ext20k.bed) \
    -b ../../data/hic/DI/D00_HiC_Rep1.10000.50.DI.bedGraph \
    -wo > evolution_analysis/D00_HiC_Rep1.DI.overlap.HERVH.txt

# bonobo
intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$1":"$2"-"$3 } else {print $1,$2-400000,$3+400000,$4 }}' evolution_analysis/bonobo/HERVH-int.liftover.PanPan2.txt) \
    -b ../../data/monkey_data/bonobo/bonobo/bonobo.norm.DI.bedgraph \
    -wo > evolution_analysis/Bonobo.DI.overlap.HERVH.txt

# Chimpanzee
intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$1":"$2"-"$3 } else {print $1,$2-400000,$3+400000,$4 }}' evolution_analysis/chimp/HERVH-int.liftover.Pantro6.txt) \
    -b ../../data/monkey_data/chimp/chimp.mt/chimp.mt.norm.DI.bedgraph \
    -wo > evolution_analysis/Chimp.DI.overlap.HERVH.txt

# Marmoset
intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$1":"$2"-"$3 } else {print $1,$2-400000,$3+400000,$4 }}' evolution_analysis/marmoset/HERVH-int.liftover.CalJac3.txt) \
    -b ../../data/monkey_data/marmoset/marmoset/marmoset.norm.DI.bedgraph \
    -wo > evolution_analysis/Marmoset.DI.overlap.HERVH.txt

# Mouse 
intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$1":"$2"-"$3 } else {print $1,$2-400000,$3+400000,$4 }}' evolution_analysis/mouse/HERVH-int.liftover.Mm10.txt) \
    -b ~/datasets/Bonev_et_cell_2017/rep1/rep1.norm.DI.bedgraph \
    -wo > evolution_analysis/Mouse.DI.overlap.HERVH.txt





  
