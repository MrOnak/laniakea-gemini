BEGIN {
  # find all articles in the journal
  cmd = "ls ./pages/*.tmpl";
  while ((cmd | getline file) > 0) {
#    split(file, parts, "-");
#    date = sprintf("%04d-%02d-%02d", parts[1], parts[2], parts[3]);
#    files[date] = file;
    fileName = gensub(".*/([^/]+)$", "\\1", "g", file);
    gmiName  = gensub(/\.tmpl$/, ".gmi", 1, fileName);
    system("awk -f scripts/includes.awk " file " > static/" gmiName);
  }
  close(cmd);
}

