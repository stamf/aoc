#!/usr/bin/env -S awk -f

NR > 1 && $1 > p { n++; }
{ p = $1 }
END { print n; }
