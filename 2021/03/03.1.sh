#!/usr/bin/env bash

awk -F '' '
{
  for(i = 0; i < NF; i++) {
    x[i] += $(i + 1) == 1 ? 1 : -1;
  }
}

END {
  for(i = 0; i < length(x); i++) {
    n  = 2^(length(x) - i - 1);
    a += x[i] > 0 ? n : 0;
    b += x[i] < 0 ? n : 0;
  }
  print a, b, a * b
}' input
