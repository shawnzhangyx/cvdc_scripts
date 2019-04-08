for sample in $(cat ../../data/hic/meta/names.txt); do 
  echo $sample
  intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$1":"$2"-"$3 } else {print $1,$2-400000,$3+400000,$1":"$2"-"$3 }}' hervh.sorted_rnaseq.bed) \
    -b ../../data/hic/DI/${sample}.10000.50.DI.bedGraph \
  -wo > DI/${sample}.DI.overlap.txt
  done

# overlap Dixon et al samples. 
for sample in H1ESC H1MES H1MSC H1NPC H1TRO; do 
  intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$1":"$2"-"$3 } else {print $1,$2-400000,$3+400000,$1":"$2"-"$3 }}' hervh.sorted_rnaseq.bed) \
    -b ../../../Dixon_et_al_2015/$sample/${sample}.norm.DI.bedgraph \
  -wo > DI/${sample}.DI.overlap.txt
  done

# overlap with iPSC samples. 
for sample in KellyFraser.Data YinShen.Data; do 
intersectBed \
  -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$1":"$2"-"$3 } else {print $1,$2-400000,$3+400000,$1":"$2"-"$3 }}' hervh.sorted_rnaseq.bed) \
  -b ../../data/iPSC/$sample/${sample}.norm.DI.bedgraph \
  -wo > DI/${sample}.DI.overlap.txt
done

#overlap HERVH with compartments
for sample in \
    ../ab_compartments/pc1_data/D00_1_SP98_pcaOut.PC1.bedGraph \
    ../ab_compartments/pc1_data/D02_1_SP100_pcaOut.PC1.bedGraph \
    ../ab_compartments/pc1_data/D05_1_SP102_pcaOut.PC1.bedGraph ; do
    intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$1":"$2"-"$3 } else {print $1,$2-400000,$3+400000,$1":"$2"-"$3 }}' hervh.sorted_rnaseq.bed) \
    -b $sample -wo > PC1_overlap/$(basename $sample).PC1.overlap.txt
  done





# overlap TSSs with DIs. 
for sample in $(cat ../../data/hic/meta/names.txt); do
  echo $sample
  intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$4 } else {print $1,$2-400000,$3+400000,$4}}' D00.rna_seq.ranked_by_rpkm.bed) \
    -b ../../data/hic/DI/${sample}.10000.50.DI.bedGraph \
  -wo > tss_DI_profile/${sample}.DI.overlap.txt
  done

## overlap TSS and TES with DIs
sample=D00_HiC_Rep1
  intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$4 } else {print $1,$2-400000,$3+400000,$4}}' all_genes.TSSs.dist.CTCF_peaks.txt) \
    -b ../../data/hic/DI/${sample}.10000.50.DI.bedGraph \
  -wo > tss_DI_profile/all_gene.TSS.DI.overlap.$sample.txt

  intersectBed \
    -a <(awk -v OFS="\t" '{if ($2-400000 <0){print $1,0,$3+400000,$4 } else {print $1,$2-400000,$3+400000,$4}}' all_genes.TESs.dist.CTCF_peaks.txt) \
    -b ../../data/hic/DI/${sample}.10000.50.DI.bedGraph \
  -wo > tss_DI_profile/all_gene.TES.DI.overlap.$sample.txt

