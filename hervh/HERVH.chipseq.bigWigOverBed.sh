cd ../../analysis/hervh/
mkdir chipseq_bwOverBed
for factor in $(cat /mnt/silencer2/home/shz254/projects/H1/ENCODE/bigWig/factors.txt); do
  echo $factor
  ~/software/ucsc/bigWigAverageOverBed /mnt/silencer2/home/shz254/projects/H1/ENCODE/bigWig/${factor}-human.rep1,2.bigWig hervh.ext20k.bed chipseq_bwOverBed/ENCODE.$factor.out
  done

~/software/ucsc/bigWigAverageOverBed ../../data/rad21/D0_Rad21.bw hervh.ext20k.bed chipseq_bwOverBed/Jian.RAD21.out

~/software/ucsc/bigWigAverageOverBed ../../data/rad21/bigWig/SMC1.bw hervh.ext20k.bed chipseq_bwOverBed/RIC.SMC1.out

~/software/ucsc/bigWigAverageOverBed ../../data/rad21/bigWig/SMC3.bw hervh.ext20k.bed chipseq_bwOverBed/RIC.SMC3.out


