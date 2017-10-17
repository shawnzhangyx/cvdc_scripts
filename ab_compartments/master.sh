cd  ../../analysis/ab_compartments/
###### building the basic directory structure
mkdir pc1_data clusters compartmentSwitch

## transfering the data. 
pushd pc1_data
cp /mnt/silencer2/home/spreissl/CVDC/HiC/Analysis/AB_Compartments/* .
## rename the files 
bash ../../../scripts/convertFileNamesWithNumbers.sh
popd
## combine the matrix across stage
Rscript combineAcrossStage.r

## cluster the matrix and ouptut compartments that switch from A/B to B/A.
Rscript clusterMatrix.r

## calculate compartment A B trans-contacts. 
bash run_calc_ab_trans_contacts.sh
  #- Rscript calc_ab_trans_contacts.r
  #- Rscript calc_ab_trans_bins.r
Rscript cal_ab_trans_contact_ave.r

## calculate the AB compartments switch
Rscript calcCompartmentSwitchesBetweenStages.r

## overlap genes with compartment switches
bash overlapGenes_compartmentSwitch.sh
## Align the clustering matrix to Gene & perfrom clustering. 
bash overlapMatrixToGene.sh
 ## python processMatrixGene.py

## calculate compartment switches between stages. 
Rscript calcCompartmentSwitchesBetweenStages.r

