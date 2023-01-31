BEGIN {
  # find all articles in the journal
  cmd = "ls ./journal/*.article";
  while ((cmd | getline file) > 0) {
    split(file, parts, "-");
    date = sprintf("%04d-%02d-%02d", parts[1], parts[2], parts[3]);
    files[date] = file;
  }
  close(cmd);
  # sort by date as per filename
  i = 0;
  for (date in files) {
    dates[++i] = date;
  }
  n = asort(dates);
  # generate journal index
  print "<= partials/header.journal-index.tmpl" > "pages/journal/index.tmpl";
  for (i = 1; i <= n; i++) {
    fileName = gensub(".*/([^/]+)$", "\\1", "g", files[dates[n - i + 1]]);
    print gensub(/\.article$/, ".gmi", 1, "=> " fileName) >> "pages/journal/index.tmpl";
  }
}

