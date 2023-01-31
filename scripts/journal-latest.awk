BEGIN {
  articleNum = 10;

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
  # generate journal.tmpl file of newest 10 articles
  print "<= partials/header.tmpl" > "pages/journal.tmpl";
  print "" > "pages/journal.tmpl";
  print "# Laniakea" > "pages/journal.tmpl";
  print "" > "pages/journal.tmpl";

  for (i = 1; i <= n && i <= articleNum; i++) {
    fileName = gensub(".*/([^/]+)$", "\\1", "g", files[dates[n - i + 1]]);
    tmplName = gensub(/\.article$/, ".tmpl", 1, fileName);
    gmiName  = gensub(/\.article$/, ".gmi", 1, fileName);
    print "<= "files[dates[n - i + 1]] >> "pages/journal.tmpl";
  }
  if (n > articleNum) {
    print "<= partials/footer.journal.tmpl" >> "pages/journal.tmpl";
  }
}

