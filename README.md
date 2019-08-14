## Summary 
This is a collection of scripts for the analysis of the Hi-C and other epigenomics data from in vitro differentiation of human cardiomyocytes. With these data we unexpected discovered a role for endogeneous retrovirus in creating chromatin domain boundaries in human pluripotent stem cells. The study has been deposited in the following preprint: 

[3D Chromatin Architecture Remodeling during Human Cardiomyocyte Differentiation Reveals A Role Of HERV-H In Demarcating Chromatin Domains
](https://www.biorxiv.org/content/10.1101/485961v2)

The HERV-H part of this story is now published in [*Nature Genetics*](https://www.nature.com/articles/s41588-019-0479-7). 

## Overall structure. 

I apologize for the lack of documentation at a lot of places in the scripts. More than half of the scripts were explorative analysis and did not lead to any fruitful ends for us. But feel free to use them for your own analysis if you find them helpful. Feel free to [e-mail me](mailto:shz254@ucsd.edu) if you have any questions about any part of the scripts. 

The project directory was designed in the following way. The files in the `scripts/` directory are exactly the files in this Github repo. 
```
project CVDC
   ├── scripts/***[everything in this Github repository]***
   ├── data/
   |     ├── Hi-C/
   |    ...
   |     └── ChIP-seq/
   ├── analysis
   |   ├── analysis 1/
   |  ...
   |   └── analysis N/
   | 
   ├── software
   ├── reference_database
   └── other directories    
```

Basically in every scritp sub-directory, there is a ``master.sh`` file (Very similar to a README file, but with commands) that tells you the order (and information) of the scripts to be run.

## Read Alignment and initial processing
The read alignment and basic processing were performed by our in-house pipelines. 
* Hi-C: https://github.com/ren-lab/hic-pipeline
* RNA-seq: https://github.com/ren-lab/rnaseq-pipeline
* ChIP-seq: https://github.com/ren-lab/chip-seq-pipeline

## Subfolder Information.

* **HiCProcessing**: prepross the Hi-C fastq files to read alignments and other statistics, including DIs, insulator scores, etc.
* **ab_compartments**: calculate compartment A/B scores, and call dynamic compartment changes. 
* **arrowhead_tads**: call TADs using arrowhead algorithm. 
* **atacProcessing**: process ATAC-seq data.
* **chipProcessing**: Process ChIP-seq data. 
* compareVISTA: compare the loops to VISTA database. 
* **customLoops: chromatin loop identification and analysis. **
* **di_tads.10k.2M**: TAD analysis using Directionality index at 10kb resolution and 2Mb distance cutoff. 
* **di_tads**: TAD analysis using Directionality index at 50kb resolution and 2Mb distance cutoff. 
* figures: plot the distance-based contact distribution and virtual 4C. 
* **GWASAnalysis**: analysis of GWAS SNPs intersecting with chromatin loop anchors. 
* **hervh: HERV-H related analysis and plots.** 
* **hervh_Ki_analysis**: analysis of HERV-H KI data.
* **insulation_tads**: call TADS using insulation score. 
* makeAnnotation: make annotation files for repeats and genes. 
* makeUCSCtrackhub: create trackhub files for UCSC genome browser. 
* matrixProcessing: dump matrix from Juicebox. 
* monkey_data_analysis: plotting the primate iPSC data. 
* qualityControl: some scripts for plotting correlation of samples. 
* **rnaseqProcessing**: process RNA-seq data
* tfChIPseqProcessing: process TF ChIP-seq data (including CTCF). 
* utility: some general purpose functions. 




