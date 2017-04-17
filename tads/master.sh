## copy the files 
# insulation
cp ~/../spreissl/CVDC/HiC/Analysis/Insulation/* ../../analysis/tads/insulation_data/
cp ~../spreissl/CVDC/HiC/Analysis/TADs/D* ../../analysis/tads/tad_calls/
## rename files
bash rename_files.sh

## combine insulation across stages.
combineAcrossStage.r
## cluster insulation sctores across stages. 
Rscript clusterMatrix.r

