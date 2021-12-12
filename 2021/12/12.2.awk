#!/usr/bin/env -S awk -F- -f

function p(node, paths, s, i, z) {
  if (node == "end") {
    count++;
    return;
  }
  if (node ~ /^[a-z]+$/) {
    split(paths, z, "," node ",")
    if (length(z) > 1) {
      if (s) { return; }
      s = 1;
    }
  }

  for(i = 0; i < length(path[node]); i++) {
    if (path[node][i] != "start") {
      p(path[node][i], paths "," node, s);
    }
  }
}

{
  path[$1][length(path[$1])] = $2;
  path[$2][length(path[$2])] = $1;
}

END {
  p("start");
  print count;
}
