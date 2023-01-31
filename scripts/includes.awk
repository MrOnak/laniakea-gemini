{
  if ($0 ~ /^<=/) {
    split($0, inclPath, " ");
    while (getline inclLine < inclPath[2] > 0) {
      if (inclLine ~ /^<=/) {
        close(inclPath[2]);
        split(inclLine, inclPath, " ");
      } else {
        print inclLine;
      }
    }
    close(inclPath[2]);

  } else {
    print;
  }
}
  
