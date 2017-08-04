cd ../../data/tfChIPseq/merged_peaks
mark=CTCF
bash  ~/software/github/seq-min-scripts/bed_to_saf.sh ${mark}_merged_peaks.bed ${mark}_peaks.saf

wait; echo "conversion to SAF done"

cd ../
if [ ! -d counts ]; then mkdir counts; fi
#for mark in CTCF
#  do
  files=$(ls bam/${mark}_*_merged.bam)
  featureCounts -a merged_peaks/${mark}_peaks.saf -o counts/${mark}.counts $files -F SAF -T 8
#  done
wait; echo "feature counts done"


