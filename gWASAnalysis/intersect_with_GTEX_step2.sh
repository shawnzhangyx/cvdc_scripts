for line in $(cut -d' ' -f 2  rs_id); do 
  echo $line
  id=$line
  nline=$(grep $id ../../data/GTEX/GTEx_Analysis_v7.metasoft.txt |wc -l)
  echo $line $nline >> rs_id.sig.txt
  done

