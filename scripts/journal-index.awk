function getDateAndTitle(file) {
  date = "";
  text = "";
  for (line = 0; line < 2; line++) {
    if (getline inclLine < file > 0) {
      if (line == 0) {
        text = substr(inclLine, 4);
      } else if (line == 1) {
        date = inclLine;
        break;
      }
    }
  }
  return date " " text;
}

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
  for (i = 1; i <= n; i++) {
    fileName = gensub(".*/([^/]+)$", "\\1", "g", files[dates[n - i + 1]]);
    linktext = getDateAndTitle(files[dates[n -i + 1]]);
    print gensub(/\.article$/, ".gmi", 1, "=> " fileName) " " linktext >> "partials/journal-entries.partial";
  }
  system("awk -f scripts/includes.awk pages/journal/index.tmpl > static/journal/index.gmi");
}

