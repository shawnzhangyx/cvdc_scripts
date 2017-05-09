import sys

def generate_marginal_sum(fname, mar_fname):
  print("processing %s for marginal counts"%fname)
  margin_count = {}
  with open(fname,'r') as fopen:
    num = 0
    for line in fopen:
      num += 1
      if num % 1000000 ==0:
        print("%d lines processed"%num)
      anchor1,anchor2,contact = line.strip().split('\t')
      if contact == "NaN":
        continue
      contact = float(contact)
      try: margin_count[anchor1] += contact
      except KeyError:
        margin_count[anchor1] = contact
      try: margin_count[anchor2] += contact
      except KeyError:
        margin_count[anchor2] = contact

  with open(mar_fname,'w') as fout:
    for key in margin_count:
      fout.write("\t".join([key,str(int(margin_count[key]))])+'\n')
  print("Finished counting marginal contacts")

if __name__ == "__main__":
  generate_marginal_sum(sys.argv[1],sys.argv[1]+".mar")
