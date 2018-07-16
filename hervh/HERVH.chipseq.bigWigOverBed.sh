cd ../../analysis/hervh/
mkdir chipseq_bwOverBed
for factor in $(cat /mnt/silencer2/home/shz254/projects/H1/ENCODE/bigWig/factors.txt); do
  echo $factor
  ~/software/ucsc/bigWigAverageOverBed /mnt/silencer2/home/shz254/projects/H1/ENCODE/bigWig/${factor}-human.rep1,2.bigWig hervh.ext20k.bed chipseq_bwOverBed/ENCODE.$factor.out
  done

~/software/ucsc/bigWigAverageOverBed ../../data/rad21/D0_Rad21.bw hervh.ext20k.bed chipseq_bwOverBed/Jian.RAD21.out
~/software/ucsc/bigWigAverageOverBed ../../data/rad21/D0_CTCF.bw hervh.ext20k.bed chipseq_bwOverBed/Jian.CTCF.out
~/software/ucsc/bigWigAverageOverBed ../../data/tfChIPseq/bigWig/CTCF_D00_merged.rpkm.bw hervh.ext20k.bed chipseq_bwOverBed/Zhang.CTCF.out
~/software/ucsc/bigWigAverageOverBed ../../data/tfChIPseq/bigWig/CTCF_D02_merged.rpkm.bw hervh.ext20k.bed chipseq_bwOverBed/Zhang.CTCF_D02.out



~/software/ucsc/bigWigAverageOverBed ../../data/rad21/bigWig/SMC1.bw hervh.ext20k.bed chipseq_bwOverBed/RIC.SMC1.out

~/software/ucsc/bigWigAverageOverBed ../../data/rad21/bigWig/SMC3.bw hervh.ext20k.bed chipseq_bwOverBed/RIC.SMC3.out

~/software/ucsc/bigWigAverageOverBed ../../../H1/ENCODE/bigWig/ENCFF348QBX.bigWig hervh.ext20k.bed chipseq_bwOverBed/ENCODE.Stanford.RAD21.out
~/software/ucsc/bigWigAverageOverBed ../../../H1/ENCODE/bigWig/ENCFF491HEO.bigWig hervh.ext20k.bed chipseq_bwOverBed/ENCODE.HAIB.RAD21.out
~/software/ucsc/bigWigAverageOverBed ../../data/rad21/bigWig/SRR6389420_1.filt.nodup.srt.bw hervh.ext20k.bed chipseq_bwOverBed/SRR6389420.RAD21.out

~/software/ucsc/bigWigAverageOverBed ../../data/tfChIPseq/chipseq_pipe_q0/bigWig/YZh10_R1.filt.nodup.srt.bw hervh.ext20k.bed chipseq_bwOverBed/YZh10.RAD21.out


