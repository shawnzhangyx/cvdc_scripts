bash preProcessData.sh
Rscript findLoopsLinkingTwoH3K27me3Peak.r

for chr in {1..22..1} X
  do
  Rscript extractInteractions.r $chr &
  done

