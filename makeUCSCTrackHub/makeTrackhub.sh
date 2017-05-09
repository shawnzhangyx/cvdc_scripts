mkdir ../../data/trackhub/
## create the hub.txt file
echo "hub cvdc
shortLabel cvdc
longLabel cvdc data
genomesFile genomes.txt
email shz254@ucsd.edu
descriptionUrl ucscHub.html" \
> ../../data/trackhub/hub.txt
## create the genomes.txt file
echo "genome hg19
trackDb hg19/trackDb.txt" \ 
> ../../data/trackhub/genomes.txt
## create the trackdb directory and files
mkdir ../../data/trackhub/hg19


