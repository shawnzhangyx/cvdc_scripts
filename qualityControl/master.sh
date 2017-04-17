mkdir ../../analysis/qualityControl
mkdir ../../analysis/qualityControl/contactMatrix_lt5m
bash processMatrixForCorrelation.sh
Rscript combineSamples.r
