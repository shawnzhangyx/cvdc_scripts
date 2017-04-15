import os
import gzip
#anchor_file 
anchors = 2880



def main(argv):
  os.chdir("../../analysis/fithic/")
  file_list = os.listdir("./results")
  for file in ["/".join([x,"14.norm.spline_pass2.significances.txt.gz"]) for x in file_list]:
    map_sig_interaction_with_anchor(anchor,
    with gzip.open(file,'r')as f: 
      for line in f: 
        
