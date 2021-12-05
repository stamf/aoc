#!/usr/bin/env bash

sed 's/ -> /,/' input \
  | awk -F, '
      $1 == $3 {
        y0 = $2 < $4 ? $2 : $4;
        y1 = $2 < $4 ? $4 : $2;

        for(i = y0; i <= y1; i++) {
          printf("%d,%d\n", $1, i);
        }
      }
      $2 == $4 {
        x0 = $1 < $3 ? $1 : $3;
        x1 = $1 < $3 ? $3 : $1;

        for(i = x0; i <= x1; i++) {
          printf("%d,%d\n", i, $2);
        }
      }
      ($1 - $3)^2 == ($2 - $4)^2 {
        i = $1; j = $2;
        x = $1 < $3 ? 1 : -1;
        y = $2 < $4 ? 1 : -1;
        d = ($3 - $1) * x;
        for(z = 0; z <= d; z++) {
          printf("%d,%d\n", i, j);
          i += x; j += y;
        }
      }
    ' \
  | sort \
  | uniq -d \
  | wc -l
