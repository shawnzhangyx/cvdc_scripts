
with open("matrix_overlap_with_gene.bed",'r') as f:
  dic = dict()
  for lines in f:
    words = lines.strip().split("\t")
    bin = tuple(words[:9])
    gene = words[-3]
    try: 
      dic[bin].append(gene)
    except KeyError:
      dic[bin] = [gene]

with open("matrix_for_clustering.txt",'w') as f:
  f.write('\t'.join(['name','D00','D02','D05','D07','D15','D80'])+'\n')
  for key in dic:
    if dic[key] != ['.']:
      genes = set(dic[key])
      name =  key[0]+':'+key[1]+"-"+key[2] +'|'+ ','.join(genes)
    else: 
      name = key[0]+':'+key[1]+"-"+key[2]
    f.write(name+'\t'+ '\t'.join(key[3:]) +'\n')

