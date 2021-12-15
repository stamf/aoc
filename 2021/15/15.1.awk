#!/usr/bin/env -S awk -f

BEGIN { N = 10e6; scale = scale ? scale : 1; }

{
  split($0, line, "");
  ncol = length(line);
  for (i = 1; i <= ncol; i++) {
    for (_x = 0; _x < scale; _x++) {
      pos = NR "," (i + ncol * _x)
      z[pos] = (line[i] + _x - 1) % 9 + 1;
      d[pos] = N;
    }
  }

  q[1 "," 1] = 0;
  d[1 "," 1] = 0;
}

function setQ(x, y, w, pos) {
  if (x < 1 || y < 1 || x > scale * nrow || y > scale * ncol) { return; }
  pos = x "," y
  if (s[pos] > 0) { return; }
  new = w + z[pos]
  q[pos] = !q[pos] || new < q[pos] ? new : q[pos];
}

function step(p, fst) {
  asorti(q, p, "@val_num_asc");

  fst = p[1];
  if (!fst) { return 0; }

  s[fst]++;
  split(fst, x, ",");
  d[fst] = q[fst];
  setQ(x[1] + 1, x[2], d[fst]);
  setQ(x[1] - 1, x[2], d[fst]);
  setQ(x[1], x[2] + 1, d[fst]);
  setQ(x[1], x[2] - 1, d[fst]);

  delete q[fst];
  return 1;
}

END {
  nrow = NR;

  for (_y = 1; _y < scale; _y++) {
    for (j = 1; j <= nrow; j++) {
      for (i = 1; i <= ncol * scale; i++) {
        pos = (nrow * _y + j) "," i
        z[pos] = (z[j "," i] + _y - 1) % 9 + 1;
        d[pos] = N;
      }
    }
  }

  while (step()) {}
  print d[scale * nrow "," scale * ncol];
}
