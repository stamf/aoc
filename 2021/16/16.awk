#!/usr/bin/env -S awk -f

BEGIN { Z = ""; }

function hex2bin(x) {
  switch(x) {
    case "0": return "0000";
    case "1": return "0001";
    case "2": return "0010";
    case "3": return "0011";
    case "4": return "0100";
    case "5": return "0101";
    case "6": return "0110";
    case "7": return "0111";
    case "8": return "1000";
    case "9": return "1001";
    case "A": return "1010";
    case "B": return "1011";
    case "C": return "1100";
    case "D": return "1101";
    case "E": return "1110";
    case "F": return "1111";
  }
}

function bin2dec(b, zz, q, ans) {
  split(b, zz, "");
  ans = 0;
  for(q = 1; q <= length(zz); q++) {
    ans += zz[q] * 2 ^ (length(zz) - q);
  }
  return ans;
}

function apply(type, cur, new) {
  switch (type) {
    case 0: return cur == Z ? new : cur + new;
    case 1: return cur == Z ? new : cur * new;
    case 2: return cur == Z ? new : (cur < new ? cur : new);
    case 3: return cur == Z ? new : (cur > new ? cur : new);
    case 5: return cur == Z ? new : cur  > new;
    case 6: return cur == Z ? new : cur <  new;
    case 7: return cur == Z ? new : cur == new;
  }
}

function handle_packet(str, ptr, n, r, ans, type, init, len, num, i) {
  n++;
  init = ptr

  if (length(str) - ptr < 10) { res_len[n] = 0; return n; }

  ver += bin2dec(substr(str, ptr, 3)); ptr += 3;
  type = bin2dec(substr(str, ptr, 3)); ptr += 3;
  ans  = Z

  if (type == 4) {

    while (substr(str, ptr, 1) == "1") {
      ans = ans "" substr(str, ptr + 1, 4); ptr += 5;
    }

    ans = ans "" substr(str, ptr + 1, 4); ptr += 5;
    ans = bin2dec(ans);

  } else {

    ptr += 1;

    if (substr(str, ptr - 1, 1) == "0") {
      len  = bin2dec(substr(str, ptr, 15)); ptr += 15;
      len += ptr

      do {
        r = handle_packet(substr(str, ptr, len - ptr + 1), 1)
        ptr += res_len[r];
        if (res_len[r] > 0) { ans = apply(type, ans, res_val[r]); }
      } while (res_len[r] > 0);

    } else {
      num = bin2dec(substr(str, ptr, 11)); ptr += 11;

      for (i = 1; i <= num; i++) {
        r = handle_packet(substr(str, ptr), 1);
        ptr += res_len[r]
        if (res_len[r] > 0) { ans = apply(type, ans, res_val[r]); }
      }

    }
  }

  res_len[n] = ptr - init; res_val[n] = ans; return n;
}

{
  split($0, c, "");
  str = ""
  for (i = 1; i <= length(c); i++) {
    str = str "" hex2bin(c[i]);
  }

  x = handle_packet(str, 1);

  print "version sum:", ver;
  print "packet calc:", res_val[x];
}
