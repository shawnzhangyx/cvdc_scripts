mkdir ../../analysis/qualityControl
mkdir ../../analysis/qualityControl/contactMatrix_lt5m
bash processMatrixForCorrelation.sh
Rscript combineSamples.r
## 
bash count_raw_reads.sh

bash D15vsD00.distance.fc.r

