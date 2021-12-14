#!/usr/bin/env -S awk -f

NR == 1 {
  split($0, input, "");
  for (i = 1; i < length(input); i++) {
    parts[input[i] "" input[i + 1]]++;
    counts[input[i]]--;
  }
  counts[input[1]]++;
}

/->/ {
  pairs[$1] = $3;
}

END {

  for(i = 0; i < 40; i++) {
    delete init;
    for(k in parts) { init[k] = parts[k]; }

    delete parts;
    for(k in init) {
      split(k, x, "");
      new = pairs[k];
      parts[x[1] "" new] += init[k];
      parts[new "" x[2]] += init[k];
      counts[new] -= init[k];
    }
  }

  for(k in parts) {
    split(k, p, "");
    counts[p[1]] += parts[k];
    counts[p[2]] += parts[k];
  }

  asort(counts, final, "@val_num_desc");
  print final[1] - final[length(final)]
}
