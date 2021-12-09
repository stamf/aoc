#!/usr/bin/env bash

< input awk '
NR == 1 {
  _a = $0;
  split($0, a, "");
  next;
}

NR == 2 {
  _b = $0;
  split($0, b, "");
  if (a[1] < a[2] && a[1] < b[1]) {
    print NR - 1, 1
  }
  for(i = 2; i < length(a); i++) {
    if (a[i] < a[i - 1] && a[i] < a[i + 1] && a[i] < b[i]) {
      print NR - 1, i
    }
  }
  if (a[i] < a[i - 1] && a[i] < b[i]) {
    print NR - 1, i
  }
  next;
}

NR == 3 {
  _c = $0; split($0, c, "");
  if (b[1] < a[1] && b[1] < b[2] && b[1] < c[1]) {
    print NR - 1, 1
  }

  for(i = 2; i < length(b); i++) {
    if (b[i] < b[i - 1] && b[i] < b[i + 1] && b[i] < a[i] && b[i] < c[i]) {
      print NR - 1, i
    }
  }

  if (b[i] < b[i - 1] && b[i] < c[i] && b[i] < a[i]) {
    print NR - 1, i
  }
  next;
}

{
  delete a; _a = _b; split(_a, a, "");
  delete b; _b = _c; split(_b, b, "");
  delete c; _c = $0; split(_c, c, "");
  if (b[1] < a[1] && b[1] < b[2] && b[1] < c[1]) {
    print NR - 1, 1
  }

  for(i = 2; i < length(b); i++) {
    if (b[i] < b[i - 1] && b[i] < b[i + 1] && b[i] < a[i] && b[i] < c[i]) {
      print NR - 1, i
    }
  }

  if (b[i] < b[i - 1] && b[i] < c[i] && b[i] < a[i]) {
    print NR - 1, i
  }
}

END {
  if (c[1] < b[1] && c[1] < c[2]) {
    print NR, 1
  }

  for(i = 2; i < length(c); i++) {
    if (c[i] < c[i - 1] && c[i] < c[i + 1] && c[i] < b[i]) {
      print NR, i
    }
  }

  if (c[i] < c[i - 1] && c[i] < b[i]) {
    print NR, i
  }
}' | awk '
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
}'
