#!/usr/bin/env -S awk -f

BEGIN {
  step = 0;
  split("", s);
}

function dostep(x, y) {
  if (x > 10 || y > 10 || x < 1 || y < 1) { return; }

  s[y][x]++;

  if (s[y][x] == 10) {
    dostep(x - 1, y - 1);
    dostep(x    , y - 1);
    dostep(x + 1, y - 1);
    dostep(x - 1, y);
    dostep(x + 1, y);
    dostep(x - 1, y + 1);
    dostep(x    , y + 1);
    dostep(x + 1, y + 1);
  }
}

{
  split($0, a, "");
  for (j = 1; j <= length(a); j++) {
    s[NR][j] = a[j];
  }
}

END {

  for(z = 0; z < 100; z++) {
    for(i = 1; i <= length(s); i++) {
      for(j = 1; j <= length(s[i]); j++) {
        dostep(i, j);
      }
    }

    for(i = 1; i <= length(s); i++) {
      for(j = 1; j <= length(s[i]); j++) {
        if (s[i][j] > 9) {
          pops++;
          s[i][j] = 0;
        }
      }
    }
  }

  print pops;
}
