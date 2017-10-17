pushd ../../analysis/tads/
outdir=figures/TAD_examples/
mkdir -p $outdir
Rscript ../../scripts/utility/plot_tad_stages.r 10 53780000  53990000 $outdir &
Rscript ../../scripts/utility/plot_tad_stages.r 14 38370000  38670000 $outdir &
Rscript ../../scripts/utility/plot_tad_stages.r 2  77170000  77320000 $outdir &
Rscript ../../scripts/utility/plot_tad_stages.r X  4190000 4450000 $outdir &
Rscript ../../scripts/utility/plot_tad_stages.r 13 55870000  56120000  $outdir &
Rscript ../../scripts/utility/plot_tad_stages.r 4  65470000  65830000  $outdir &
#Rscript ../../scripts/utility/plot_tad_stages.r 13 31210000  31630000  $outdir  &

