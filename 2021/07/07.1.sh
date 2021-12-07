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
        z = j - i;
        sum += x[j] * (z >= 0 ? z : -z);
      }
      best = best == 0 || sum < best ? sum : best;
    }
    print best
  }
' input
