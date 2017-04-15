cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/hic/
if [ ! -d dixonMatrix/ ]; then mkdir dixonMatrix; fi
for folder in $(ls -d matrix/D*) 
  do 
  python /mnt/silencer2/home/yanxiazh/software/github/hic-kit/hic_to_dixon.py $folder/14_10000.txt ${folder/matrix/dixonMatrix}.chr14.norm.txt &
  done
wait 
echo done
#python /mnt/silencer2/home/yanxiazh/software/github/hic-kit/hic_to_dixon.py matrix_raw/D0_HiC_Rep1/14_10000.txt dixonMatrix/D0_HiC_Rep1.raw.txt

