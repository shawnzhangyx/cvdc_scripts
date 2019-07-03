############################
## This script will find all the matepairs anchoring in a certain
## genomic region. There are two output files:
## POS 1: the read position within the genomic region
## POS 2: the read mapping to alternative region.
## #########################

import sys
import os
import pysam

usage='''%prog chr start end outprefix
'''
def main(argv):
  if len(argv) != 2:
    print(usage)
    exit(1)
  outprefix = argv[1]
  for filename in ["../../analysis/phasing/MSX1/MSX1.combined.raw.bam"]:
    sam = pysam.Samfile(filename,'rb')
    name=os.path.basename(filename)
    outsam = pysam.AlignmentFile(outprefix+name,'wb',template=sam)
    num = 0
    for read in sam.fetch():
      num += 1
      if num % 100 == 0:
        print(num, "lines processed")
      #if sam.mate(read):
      #  print("yes")
      try:
        outsam.write(read)
        outsam.write(sam.mate(read))
      except ValueError: 
        pass


if __name__ == "__main__":
  main(sys.argv)


