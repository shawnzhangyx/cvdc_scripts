cd  ../../analysis/ab_compartments/clusters/
intersectBed -a matrix_for_clustering.bed -b ~/annotations/hg19/gencode.v19.annotation.transcripts.tss10k.bed -loj > matrix_overlap_with_gene.bed
python ../../../scripts/ab_compartments/processMatrixGene.py
~/software/cluster-1.52a/bin/cluster -f matrix_for_clustering.txt -g 7 -e 7 -m a 
