#!/usr/bin/env -S awk -f

BEGIN {
  r = 1;
  while (getline < "input") {
    delete a;
    split($0, a, "");

    for(c = 1; c <= length(a); c++) {
      pos[r "," c] = a[c];
    }
    r++;
  }
  close("input")
}

function search(row, col, prev, cur) {
  k = row "," col;
  if (visit[k] >= 4) { return 0; }
  if (valid[k] >  0) { return 0; }
  cur = pos[k];

  if (cur == "9" || cur == "") { return 0; }
  visit[k] += 1;

  if (cur > prev) {
    valid[k] = 1;

    return 1 \
      + search(row + 1, col, cur) \
      + search(row - 1, col, cur) \
      + search(row, col + 1, cur) \
      + search(row, col - 1, cur);
  }
}

{ size[NR] = search($1, $2, -1); }

END {
  asort(size);
  print size[NR] * size[NR - 1] * size[NR - 2];
}
