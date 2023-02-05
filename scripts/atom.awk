function getDateAndTitle(file) {
  for (line = 0; line < 4; line++) {
    if (getline inclLine < file > 0) {
      switch (line) {
        case 0:
          articleData["title"] = substr(inclLine, 4);
          break
        case 1:
          articleData["date"] = inclLine "T00:00:00Z";
          break
        case 3:
          articleData["abstract"] = inclLine;
          break
      }
    }
  }
}

BEGIN {
  host = "gemini://laniakea.rodoste.de/";
  articleData[""] = 1
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
  # generate the header
  print "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
  print "<feed xmlns=\"http://www.w3.org/2005/Atom\">";
  print "  <title>Laniakea Journal</title>";
  print "  <link href=\"" host "journal/index.gmi\" rel=\"alternate\" />";
  print "  <link href=\"" host "atom.xml\" rel=\"self\" />";
  print "  <updated>" curdate "</updated>";
  print "  <author>";
  print "    <name>Dominique, Anoikis Nomads</name>";
  print "  </author>";
  print "  <generator uri=\"https://www.gnu.org/software/gawk\" version=\"5.2.1\">GNU Awk</generator>";
  print "  <id>" host "journal/index.gmi</id>";

  # build entries per feed
  for (i = 1; i <= n; i++) {
    # fetch publish date and title
    getDateAndTitle(files[dates[n - i + 1]]);
    filename = gensub(".*/([^/]+)$", "\\1", "g", files[dates[n - i + 1]]);
    filename = gensub(/\.article$/, ".gmi", 1, filename);
    print "  <entry>";
    print "    <id>" host "journal/" filename "</id>";
    print "    <title>" articleData["title"] "</title>";
    print "    <updated>" articleData["date"] "</updated>";
    print "    <summary>" articleData["abstract"] "</summary>";
    print "    <link href=\"" host "journal/" filename "\" rel=\"alternate\"/>";
    print "  </entry>";
  }
  # close the feed
  print "</feed>";
}
