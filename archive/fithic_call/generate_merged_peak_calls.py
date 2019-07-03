import gzip
import multiprocessing as mlp

def combine_replicate(fname1, fname2, fun):
   list1 = []
   list2 = []
   print("processing  "+fname1)
   with open(fname1,'r') as f1:
     for line in f1: 
       chr1,mid1,chr2,mid2,count,pval,qval=line.strip().split('\t')
       list1.append((chr1,mid1,mid2))
   print("processing  "+fname2)
   with open(fname2,'r') as f2:
     for line in f2: 
       chr1,mid1,chr2,mid2,count,pval,qval=line.strip().split('\t')
       list2.append((chr1,mid1,mid2))
   if fun == "intersect":
     return set(list1) & set(list2)
   elif fun == "union":
     return set(list1) | set(list2)
   else: 
     raise Exception("Unknown function")

def worker(chrom):
  prefix="../../analysis/fithic/results/"
  affix="/q0.01/"+chrom+".significant.txt"
  inter_set = set([])
  union_set = set([])  
  with open("../../data/hic/meta/names.txt",'r') as f:
    names = f.readlines()
    print(names)
    for i in range(int(len(names)/2)):
      print(i)
      results = combine_replicate(prefix+names[i*2].strip()+affix,prefix+names[i*2+1].strip()+affix, "intersect")
      inter_set = inter_set | results 
      results = combine_replicate(prefix+names[i*2].strip()+affix,prefix+names[i*2+1].strip()+affix, "union")
      union_set = union_set | results

  with open("../../analysis/fithic/merged_peaks/"+chrom+".rep_inter.txt",'w') as out:
    for (chr1,mid1,mid2) in inter_set: 
      out.write('\t'.join([chr1,mid1,chr1,mid2])+'\n')
  with open("../../analysis/fithic/merged_peaks/"+chrom+".rep_union.txt",'w') as out:
    for (chr1,mid1,mid2) in union_set:
      out.write('\t'.join([chr1,mid1,chr1,mid2])+'\n')

    
def main():
  chroms = [str(x) for x in range(1,23)]
  chroms.append("X")
  print(chroms)
  for chrom in chroms:
    print(chrom)
    mlp.Process(target=worker, args=(chrom,)).start()


if __name__ == "__main__":
  main()
