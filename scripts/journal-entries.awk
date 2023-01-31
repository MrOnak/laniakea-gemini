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
  # generate .tmpl file for each article
  for (i = 1; i <= n; i++) {
    fileName = gensub(".*/([^/]+)$", "\\1", "g", files[dates[n - i + 1]]);
    tmplName = gensub(/\.article$/, ".tmpl", 1, fileName);
    gmiName  = gensub(/\.article$/, ".gmi", 1, fileName);
    print tmplName;
    print "<= partials/header.journal.tmpl" > "pages/journal/" tmplName;
    print "<= "files[dates[n - i + 1]] >> "pages/journal/" tmplName;
    print "<= partials/footer.journal.tmpl" >> "pages/journal/" tmplName;
    # now call another awk script to generate the .gmi from the .tmpl
    system("awk -f scripts/includes.awk pages/journal/" tmplName " > static/journal/" gmiName);
  }
}

