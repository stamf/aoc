#!/usr/bin/env -S awk -f

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
}

END { print s; }
