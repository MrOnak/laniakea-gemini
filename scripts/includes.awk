{
  if ($0 ~ /^<=/) {
    split($0, inclPath, " ");
    while (getline inclLine < inclPath[2] > 0) {
      print inclLine;
    }

  } else {
    print;
  }
}
  
