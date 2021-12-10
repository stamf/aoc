#!/usr/bin/env -S awk -f

NR == 1 {
  _a = $0;
  split($0, a, "");
  next;
}

NR == 2 {
  _b = $0;
  split($0, b, "");
  if (a[1] < a[2] && a[1] < b[1]) {
    print a[1], a[2], b[2];
  }
  for(i = 2; i < length(a); i++) {
    if (a[i] < a[i - 1] && a[i] < a[i + 1] && a[i] < b[i]) {
      print a[i], a[i - 1], a[i + 1], b[i];
    }
  }
  if (a[i] < a[i - 1] && a[i] < b[i]) {
    print a[i], a[i - 1], b[i];
  }
  next;
}

NR == 3 {
  _c = $0; split($0, c, "");
  if (b[1] < a[1] && b[1] < b[2] && b[1] < c[1]) {
    print b[1], a[1], b[2], c[1];
  }

  for(i = 2; i < length(b); i++) {
    if (b[i] < b[i - 1] && b[i] < b[i + 1] && b[i] < a[i] && b[i] < c[i]) {
      print b[i], b[i - 1], b[i + 1], a[i], c[i];
    }
  }

  if (b[i] < b[i - 1] && b[i] < c[i] && b[i] < a[i]) {
    print b[i], b[i - 1], c[i], a[i];
  }
  next;
}

{
  delete a; _a = _b; split(_a, a, "");
  delete b; _b = _c; split(_b, b, "");
  delete c; _c = $0; split(_c, c, "");
  if (b[1] < a[1] && b[1] < b[2] && b[1] < c[1]) {
    print b[1], a[1], b[2], c[1];
  }

  for(i = 2; i < length(b); i++) {
    if (b[i] < b[i - 1] && b[i] < b[i + 1] && b[i] < a[i] && b[i] < c[i]) {
      print b[i], b[i - 1], b[i + 1], a[i], c[i];
    }
  }

  if (b[i] < b[i - 1] && b[i] < c[i] && b[i] < a[i]) {
    print b[i], b[i - 1], a[i], c[i];
  }
}

END {
  if (c[1] < b[1] && c[1] < c[2]) {
    print c[1], b[1], c[2];
  }

  for(i = 2; i < length(c); i++) {
    if (c[i] < c[i - 1] && c[i] < c[i + 1] && c[i] < b[i]) {
      print c[i], c[i - 1], c[i + 1], b[i];
    }
  }

  if (c[i] < c[i - 1] && c[i] < b[i]) {
    print c[i], c[i - 1], b[i];
  }
}
