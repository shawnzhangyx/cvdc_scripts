#bash dumpBias.sh
bash convertJuicerToFitHiC_file.sh
bash fithic.sh # This step can be run on TSCC. 
bash filter_fithic_calls.sh
python generate_merged_peak_calls.py
# generate the final merged_peak calls. 
cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/fithic/merged_peaks/
cat *.rep_inter.txt |awk -v OFS='\t' '{print "chr"$1,$2,$2+10000,"chr" $3, $4,$4+10000 }'  >  rep_inter.all.txt
awk -v OFS='\t' '{print $4,$5,$6,$1,$2,$3}' rep_inter.all.txt > rep_inter.all.rev.txt
# overlap merged_peaks with histone and CTCF. 
bash overlap_fithic_peak_with_features.sh

# return the interaction frequencies. 
for chr in {1..22} X; do
  Rscript extractInteractions_for_merged_peaks.r $chr
  done
