#!/usr/bin/env bash

awk -v RS=, '
  {
    x[$1]++;
    m = $1 > m ? $1 : m;
  }

  END {
    best = 0;
    for(i = 0; i <= m; i++) {
      sum = 0;
      for(j = 0; j <= m; j++) { 
        d = j > i ? j - i : i - j;
        z = d * (d + 1) / 2;
        sum += x[j] * z;
      }
      best = best == 0 || sum < best ? sum : best;
    }
    print best
  }
' input
