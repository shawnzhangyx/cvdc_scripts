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
  if len(argv) != 5:
    print(usage)
    exit(1)
  chr = argv[1] #"chr14" #argv[2]
  start = int(argv[2]) #23866000 # argv[3]
  end = int(argv[3]) #23882000 # argv[4]
  outprefix = argv[4]
  for filename in ["../../data/hic/bams/D00_Rep1.bam"]:
    sam = pysam.Samfile(filename,'rb')
    name=os.path.basename(filename)
    outsam = pysam.AlignmentFile(outprefix+name,'wb',template=sam)
    fread_list = []
    rread_list = []
    num = 0
    for read in sam.fetch(reference=chr,start=start,end=end):
      num += 1
      if num % 100 == 0:
        print(num, "lines processed")
      fread_list.append(read.pos)
      rread_list.append(sam.mate(read).pos)
      outsam.write(sam.mate(read))
#    outf1 = open(outprefix+name+'_pos1.txt','w')
#    for pos in fread_list:
#      outf1.write(str(pos)+'\n')
    outf2 = open(outprefix+name+'_pos2.txt','w')
    for pos in rread_list:
      outf2.write(str(pos)+'\n')


if __name__ == "__main__":
  main(sys.argv)

