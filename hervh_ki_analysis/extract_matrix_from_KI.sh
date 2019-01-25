mkdir ../../analysis/hervh_ki/matrix_norm
# extract the matrix
../../scripts/utility/straw KR ../../data/herv-ko/hic/deep_run_pipe/HERV2/HERV2.hic chr20 chr20 BP 10000 > ../../analysis/hervh_ki/matrix_norm/HERV-KO.chr20.10k.mat
../../scripts/utility/straw KR ../../data/herv-ki/HERV-KI2/HERV-KI2.hic chr20 chr20 BP 10000 > ../../analysis/hervh_ki/matrix_norm/HERV-KI2.chr20.10k.mat
../../scripts/utility/straw KR ../../data/herv-ki/HERV-KI1/HERV-KI1.hic chr20 chr20 BP 10000 > ../../analysis/hervh_ki/matrix_norm/HERV-KI1.chr20.10k.mat
plot_tad.r 17400000 18000000 HERV-KO.chr20.10k.mat HERV-KI2.chr20.10k.mat HERV-KI1.chr20.10k.mat

# 5k resolution
../../scripts/utility/straw KR ../../data/herv-ko/hic/deep_run_pipe/HERV2/HERV2.hic chr20 chr20 BP 5000 > ../../analysis/hervh_ki/matrix_norm/HERV-KO.chr20.5k.mat
../../scripts/utility/straw KR ../../data/herv-ki/HERV-KI2/HERV-KI2.hic chr20 chr20 BP 5000 > ../../analysis/hervh_ki/matrix_norm/HERV-KI2.chr20.5k.mat
../../scripts/utility/straw KR ../../data/herv-ki/HERV-KI1/HERV-KI1.hic chr20 chr20 BP 5000 > ../../analysis/hervh_ki/matrix_norm/HERV-KI1.chr20.5k.mat
plot_tad.5k.r 17400000 18000000 HERV-KO.chr20.5k.mat HERV-KI2.chr20.5k.mat HERV-KI1.chr20.5k.mat


