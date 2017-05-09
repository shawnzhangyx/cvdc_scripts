cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/bams

#day=00
for day in 00 02 05 07 15 80
  do 
  (
  chrsize=/mnt/silencer2/home/yanxiazh/annotations/hg19/hg19.chrom.sizes
  nodup_bam_loc=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/bams
  expt_prefix=D${day}
  pipe_out_loc=D${day}
  mkdir $nodup_bam_loc/$pipe_out_loc
  python ~/software/github/pipeline-atac-seq/call-atac.py $nodup_bam_loc $expt_prefix $pipe_out_loc $chrsize 
  python ~/software/github/pipeline-atac-seq/run-idr.py $expt_prefix $pipe_out_loc $chrsize

  ) &

  done


