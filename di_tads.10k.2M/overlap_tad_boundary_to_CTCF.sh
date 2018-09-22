cd  ../../analysis/di_tads.10k.2M/dynamic_bd/
  intersectBed -b ../../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.overlap_stage.edger.txt -a <(awk -v OFS="\t" '{print $1,$2-15000,$2+15000}' d00.txt) -wo > d00.ovlp.CTCF.15k.txt
  intersectBed -b ../../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.overlap_stage.edger.txt -a <(awk -v OFS="\t" '{print $1,$2-15000,$2+15000}' d80.txt) -wo > d80.ovlp.CTCF.15k.txt
  
  intersectBed -b ../../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.overlap_stage.edger.txt -a <(awk -v OFS="\t" '{print $1,$2-15000,$2+15000}' stable.txt) -wo > stable.ovlp.CTCF.15k.txt
 
 ## plot the number of CTCF peaks by stage. 

 # R

