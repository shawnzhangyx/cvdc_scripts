for sample in $(cat ../../data/hic/meta/names.txt);do 
Rscript promoter_anchored.local_interaction.r ../../data/hic/matrix/$sample/14_10000.txt ${sample}.txt myh6.txt
done
