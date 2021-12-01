#!/usr/bin/env bash

paste \
  input \
  <(sed 1d input) \
  <(sed 1,2d input) \
  | awk 'NR > 1 && NF == 3 && $1 + $2 + $3 > p { n++; } { p = $1 + $2 + $3; } END { print n; }'
