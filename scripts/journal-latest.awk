BEGIN {
  articleNum = 1;

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
  # generate template header
  print "<= partials/header.partial" > "pages/journal.tmpl";
  print "" > "pages/journal.tmpl";
  print "# my latest journal entry" > "pages/journal.tmpl";
  print "" > "pages/journal.tmpl";
  # add links to newest 10 articles
  for (i = 1; i <= n && i <= articleNum; i++) {
    fileName = gensub(".*/([^/]+)$", "\\1", "g", files[dates[n - i + 1]]);
    tmplName = gensub(/\.article$/, ".tmpl", 1, fileName);
    gmiName  = gensub(/\.article$/, ".gmi", 1, fileName);
    print "<= "files[dates[n - i + 1]] >> "pages/journal.tmpl";
  }
  # add footer if needed
  if (n > articleNum) {
    print "<= partials/footer.journal.partial" >> "pages/journal.tmpl";
  }
}

