for file in * 
  do 
  [[ $file =~ D([0-9]{1})_(.*) ]] && 
    ( 
    num=$(printf "%02d" "${BASH_REMATCH[1]}");
    rest=${BASH_REMATCH[2]};
    echo "mv $file D${num}_${rest}";
    mv $file D${num}_${rest};
    )
    
  done
