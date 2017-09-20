for name in D00_HiC_Rep1  D02_HiC_Rep2  D07_HiC_Rep1  D15_HiC_Rep2 D00_HiC_Rep2  D05_HiC_Rep1  D07_HiC_Rep2  D80_HiC_Rep1 D02_HiC_Rep1  D05_HiC_Rep2  D15_HiC_Rep1  D80_HiC_Rep2; do 
 qsub -v name=$name run_test.qs 
 done
