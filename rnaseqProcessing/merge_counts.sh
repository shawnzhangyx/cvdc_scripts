pushd ../../data/rnaseq/rerun/

paste featureCounts/*.counts |tail -n +2 |grep -v chrM |cut -f 1,5,6,$(seq -s, 7 7  $((7*12))) > combined-chrM.counts


