files=$(ls hervh_rnaseq_brackets/*.bed)

#    ../../data/tfChIPseq/bigWig/Input.for_cohesin.D00.q0.rpkm.bw \
#    ../../data/tfChIPseq/bigWig/SMC3.ab9263.D00.q0.rpkm.bw \
#    ../../data/tfChIPseq/bigWig/ENCODE.H1.POLR2A.q0.rpkm.bw \
for bw in \
    ../../data/tfChIPseq/bigWig/CTCF_D00_merged.rpkm.bw \
    ~/../yanxiazh/projects/cardiac_dev/data/trackhub/hg19/rnaseq_D00.rpkm.bw \
    ../../data/tfChIPseq/bigWig/Input.for_cohesin.D00.rpkm.bw \
    ../../data/tfChIPseq/bigWig/SMC3.ab9263.D00.rpkm.bw \
    ../../data/tfChIPseq/bigWig/ENCODE.H1.POLR2A.rpkm.bw \
    ; do
    computeMatrix scale-regions -S \
    $bw \
    -R $files \
    --regionBodyLength 10000 \
    --beforeRegionStartLength 30000 \
    --afterRegionStartLength 30000 \
    --binSize 100 \
    --averageTypeBins median \
    --skipZeros -o chipseq_profiles/$(basename $bw).mat.gz

  plotProfile -m chipseq_profiles/$(basename $bw).mat.gz \
    -out chipseq_profiles/$(basename $bw).profile.pdf
  done


#SMC3.ab9263.D00.q0.rpkm.bw \
#ENCODE.H1.POLR2A.q0.rpkm.bw \
#Input.for_cohesin.D00.q0.rpkm.bw 
for name in \
  SMC3.ab9263.D00.rpkm.bw \
  ENCODE.H1.POLR2A.rpkm.bw \
  Input.for_cohesin.D00.rpkm.bw 
  do 
  Rscript smooth_profiles.r $name; 
  done

for name in SMC3.ab9263.D00.rpkm.bw \
  ENCODE.H1.POLR2A.rpkm.bw \
  do
  Rscript smooth_diff_profiles.r $name;
  done

Rscript plot_rnaseq_profile.top_hervhs.r rnaseq_D00.rpkm.bw 


