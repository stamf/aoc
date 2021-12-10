#!/usr/bin/env -S awk -f

BEGIN {
  PROCINFO["sorted_in"] = "@val_num_asc";
  split("", c);
}

{
  split($0, a, "");
  split("", b);
  for (i = 1; i <= length(a); i++) {
    if (a[i] == "[" || a[i] == "(" || a[i] == "<" || a[i] == "{") {
      b[length(b)] = a[i]; continue;
    }

    k = length(b) - 1;

    if (a[i] == "]") {
      if (b[k] == "[") {
        delete b[k]; continue;
      } else {
        s += 57; next;
      }
    }

    if (a[i] == ")") {
      if (b[k] == "(") {
        delete b[k]; continue;
      } else {
        s += 3; next;
      }
    }

    if (a[i] == ">") {
      if (b[k] == "<") {
        delete b[k]; continue;
      } else {
        s += 25137; next;
      }
    }

    if (a[i] == "}") {
      if (b[k] == "{") {
        delete b[k]; continue;
      } else {
        s += 1197; next;
      }
    }
  }

  q = 0;
  for(z = length(b); z >= 0; z--) {
    p = 0;
    switch (b[z]) {
      case "(": p = 1; break;
      case "[": p = 2; break;
      case "{": p = 3; break;
      case "<": p = 4; break;
    }

    q = q * 5 + p;
  }

  c[length(c)] = q;
}

END {
  i = 1; g = 1 + int(length(c) / 2);
  for (k in c) {
    if (i++ == g) { print c[k]; exit; }
  }
}
