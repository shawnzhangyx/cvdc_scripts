## copy the files 
# insulation
cp ~/../spreissl/CVDC/HiC/Analysis/Insulation/* ../../analysis/di_tads/insulation_data/
cp ~/../spreissl/CVDC/HiC/Analysis/TADs/D* ../../analysis/di_tads/tad_di/
## rename files
bash rename_files.sh

## combine insulation and DI across stages.
combineAcrossStage.r
## cluster insulation scores across stages. 
Rscript clusterMatrix.r
## merge tad boundaries. 
for file in $(ls tad_di/D??_Rep?.TAD.bed); do
  awk -v OFS="\t" -v name=${file/tad_di\/} '{ if(NR>1) print $0,name}' $file
    done |sort --parallel=4 -k1,1 -k2,2n -k3,3n - >> combined_tads.raw.sorted.txt


Rscript tad_boundary_replicated.r
Rscript tad_boundary_difference.r
Rscript tad_boundary_across_stages.r


# plot the TAD number
Rscript plotTadNumber.r
Rscript plotTadSize.r
