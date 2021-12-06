#!/usr/bin/env bash

sed 's/,/\n/g' input \
  | awk -v n=80 '
      { x[$1]++; }

      END {
        for(i = 0; i < n; i++) {
          x[i + 7] += x[i];
          x[i + 9] += x[i];
        }
        for(; i < length(x); i++) {
          z += x[i];
        }
        print z;
      }
    '
