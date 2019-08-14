## Summary 
This is a collection of scripts for the analysis of the Hi-C and other epigenomics data from in vitro differentiation of human cardiomyocytes. With these data we unexpected discovered a role for endogeneous retrovirus in creating chromatin domain boundaries in human pluripotent stem cells. The study has been deposited in the following preprint: 

[3D Chromatin Architecture Remodeling during Human Cardiomyocyte Differentiation Reveals A Role Of HERV-H In Demarcating Chromatin Domains
](https://www.biorxiv.org/content/10.1101/485961v2)

The HERV-H part of this story is now published in [*Nature Genetics*](https://www.nature.com/articles/s41588-019-0479-7). 

## Overall structure. 

I apologize for the lack of documentation at a lot of places in the scripts. More than half of the scripts were explorative analysis and did not lead to any fruitful ends for us. But feel free to use them for your own analysis if you find them helpful. 

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
