cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/
bash  ~/software/github/seq-min-scripts/bed_to_saf.sh peaks/atac_merged_peaks.bed peaks/atac_peaks.saf
echo "conversion to SAF done"
## count the reads
if [ ! -d counts ]; then mkdir counts; fi 
files=$(ls bams/D??_?_sorted_nodup-chrM.30.bam)
featureCounts -a peaks/atac_peaks.saf -o counts/atac.read.counts $files -F SAF -T 8
featureCounts -a peaks/atac_peaks.saf -o counts/atac.frag.counts $files -F SAF -T 8 -p 

echo "feature counts done"

## count the reads in the original file
#cd /mnt/silencer2/home/spreissl/CVDC/ATAC
#files=$(ls *nodup-chrM.30.bam)
#featureCounts -a $HOME/projects/cardiac_dev/data/atac/peaks/atac_peaks.saf -o $HOME/projects/cardiac_dev/data/atac/counts/atac.allSample.read.counts $files -F SAF -T 8
#featureCounts -a $HOME/projects/cardiac_dev/data/atac/peaks/atac_peaks.saf -o $HOME/projects/cardiac_dev/data/atac/counts/atac.allSample.frag.counts $files -F SAF -T 8 -p


