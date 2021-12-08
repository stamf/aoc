#!/usr/bin/env -S awk -f

{
  for(i = NF; i > 0; i--) {
    if ($i == "|") { break; }
    z = length($i);
    if (z == 2 || z == 4 || z == 3 || z == 7) { x++; }
  }
}

END { print x }
