import argparse
import sys
import pandas as pd
import numpy as np

def arguments():
  parser  = argparse.ArgumentParser(description="Read muscle-aligned LTRs, calculate Kimura 2 parameter distance, APPENDS TO EXISTING FILE")
  parser.add_argument("-i", "--input", help="path for input .afa file", required=True)
  parser.add_argument("-o","--output", help="path for output file", required=True)
  args = parser.parse_args()
  return(args)


def get_diffs(lines,outpath):

  '''
  Remove gaps, count differences
  '''

  s = 0
  ltrone = ''
  ltrtwo = ''

  for line in lines:

    if '>' in line:
      s+=1
    else:
      if s==1:
        ltrone+=line.rstrip()         
      elif s==2:
        ltrtwo+=line.rstrip()
      else:
        sys.exit(1)

  ltrone = pd.Series(list(ltrone))
  ltrtwo = pd.Series(list(ltrtwo))

  seqs = pd.concat([ltrone,ltrtwo],axis=1).reset_index(drop=True)
  seqs.columns = ['ltrone','ltrtwo']
  seqs = seqs[ seqs.ltrone != '-' ]
  seqs = seqs[ seqs.ltrtwo != '-' ]
  seqsdiff = seqs[ seqs.ltrone != seqs.ltrtwo ]
  seqsdiff['pair'] = seqsdiff['ltrone'] + seqsdiff['ltrtwo']
  P = seqsdiff[(seqsdiff.pair == "AG") | (seqsdiff.pair == "GA") | (seqsdiff.pair == "CT") | (seqsdiff.pair == "TC")]
  Q = seqsdiff[(seqsdiff.pair != "AG") & (seqsdiff.pair != "GA") & (seqsdiff.pair != "CT") & (seqsdiff.pair != "TC")]

  Pdiffs = P.shape[0]/seqs.shape[0]
  Qdiffs = Q.shape[0]/seqs.shape[0]

  d = np.log((1-(2*Pdiffs)-Qdiffs)*(np.sqrt(1-(2*Qdiffs)))) * -0.5

# T = (d/2) * float(mu)

  with open(outpath, "a") as outfile:
    outfile.write(inpath+"\t"+str(d)+'\n')

########################

args = arguments()

inpath = args.input
outpath = args.output

infile = open(inpath, 'r')
lines = infile.readlines()

get_diffs(lines, outpath)
