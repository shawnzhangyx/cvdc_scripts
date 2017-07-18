#!/usr/bin/env python
import argparse 
from time import time

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('--out-file', metavar='OUTPUT_FILE',dest="mat",
                    type=str, action="store",required=True,
                    help='output file')
parser.add_argument('--chr', metavar='CHR',dest="chr",
                    type=str, action="store",required=True,
                    help='output file')
parser.add_argument('--contact-file', metavar='CONTACT_FILE',dest="contacts",
                    type=str, action="store",required=True, nargs="+",
                    help='contact files')
args = parser.parse_args()


def process_contact_file(filename,contact_dict):
  tStart = time()
  with open(filename,'r') as f:
    for idx,line in enumerate(f):
      if idx % 100000 == 0:
        print(str(idx)+" "+ str(time()-tStart) )
      x1,y1,contact = line.strip().split('\t')
      try: 
        contact_dict[(x1,y1)][filename] = contact
      except KeyError:
        contact_dict[(x1,y1)] = dict()
        contact_dict[(x1,y1)][filename] = contact

  return contact_dict

def main():
  contact_dict = dict()
  for filename in args.contacts:
    print(filename)
    contact_dict = process_contact_file(filename,contact_dict)
    
  with open(args.mat,'w') as outf:
    outf.write('x1\tx2\t'+'\t'.join(args.contacts)+'\n')
    for anchor in contact_dict:
      print(anchor)
      outf.write('\t'.join(anchor) +'\t')
      contact_list = []
      for filename in args.contacts:
        if filename in contact_dict[anchor]:
          contact_list.append(contact_dict[anchor][filename])
        else:
          contact_list.append("0")
      outf.write('\t'.join(contact_list) + '\n')

if __name__ == "__main__":
  main()

