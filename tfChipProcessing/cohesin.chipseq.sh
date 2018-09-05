gs=/projects/ps-renlab/yunjiang/genomes/hg19/bwa/hg19.chrom.size
for name in RAD21_sc98784.D00 RAD21_ab992.D00 SMC3.ab9263.D00; do  
  ext_len=$(awk '{{print $10;exit}}' <(samtools view bam/$name.bam)|awk '{print 300-length}')
  scale=$(samtools idxstats bam/$name.bam | awk 'sum+=$3{print sum}' | tail -1 | awk '{print 1/$1*1000000}')
  samtools view -b bam/$name.bam | bedtools bamtobed | bedtools slop -s -l 0 -r $ext_len -i stdin -g $gs | genomeCoverageBed -g $gs -i stdin -bg -scale $scale | wigToBigWig stdin $gs bigWig/$name.bw &
 done

#        "samtools view -b {input} | bedtools bamtobed |"
#        "bedtools slop -s -l 0 -r $ext_len -i stdin -g {output.gs} |"
#        "bedtools genomecov -g {output.gs} -i stdin -bg |"
#        "{WIG2BIGWIG} stdin {output.gs} {output.bw}"

tf=RAD21_ab992.D00
for tf in SMC3.ab9263.D00; do 
macs2 callpeak -t bam/$tf.bam -c bam/Input_cohesin.D00.bam -g hs -B --SPMR -n $tf  -f BAM --outdir peaks/$tf --llocal 0
macs2 bdgcmp -t peaks/$tf/${tf}_treat_pileup.bdg -c peaks/$tf/${tf}_control_lambda.bdg -m FE -o peaks/$tf/$tf.FE.bdg
sort -k1,1 -k2,2n peaks/$tf/$tf.FE.bdg > peaks/$tf/$tf.FE.sorted.bdg
  bedGraphToBigWig  peaks/$tf/$tf.FE.sorted.bdg /projects/ps-renlab/yunjiang/genomes/hg19/bwa/hg19.chrom.size bigWig/$tf.FE.bw
done 
