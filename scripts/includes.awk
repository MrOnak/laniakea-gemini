function process_file(file) {
  if (processed[file]) return;
  processed[file] = 1;
  while (getline inclLine < file > 0) {
    if (inclLine ~ /^<=/) {
      split(inclLine, inclPath, " ");
      process_file(inclPath[2]);
    } else {
      print inclLine;
    }
  }
}

BEGIN {
  processed[""] = 1;
}

{
  if ($0 ~ /^<=/) {
    split($0, inclPath, " ");
    process_file(inclPath[2]);
  } else {
    print;
  }
}

