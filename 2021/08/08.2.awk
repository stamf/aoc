#!/usr/bin/env -S awk -f

function cmp(p1, p2, p1_, p2_, x, y) {
  p1_ = p1;
  p2_ = p2;
  x = gsub("[" p1 "]", "", p2_);
  y = gsub("[" p2 "]", "", p1_);
  #print p1, p2, x, y, p1_, p2_;
  return x "," length(p1_) "," length(p2_);
}

function ch2bin(ch, a, b) {
  split(ch, a, "");
  b = 0;
  for(g = 0; g < length(a); g++) {
    if (a[g] == "a") b +=  1;
    if (a[g] == "b") b +=  2;
    if (a[g] == "c") b +=  4;
    if (a[g] == "d") b +=  8;
    if (a[g] == "e") b += 16;
    if (a[g] == "f") b += 32;
    if (a[g] == "g") b += 64;
  }

  return b;
}

{
  for(i = 1; i < NF; i++) {
    if ($i == "|")       { sep = i; break; }
    if (length($i) == 2) { Q[ch2bin($i)] = 1; P[1] = $i; }
    if (length($i) == 3) { Q[ch2bin($i)] = 7; P[7] = $i; }
    if (length($i) == 4) { Q[ch2bin($i)] = 4; P[4] = $i; }
    if (length($i) == 7) { Q[ch2bin($i)] = 8; P[8] = $i; }
  }

  for(i = 1; i < sep; i++) {
    zz = ch2bin($i);
    d1 = cmp($i, P[1]);
    d4 = cmp($i, P[4]);
    d7 = cmp($i, P[7]);
    if (d1 == "2,3,0") {
      Q[zz] = 3; P[3] = $i;
    }
    if (d4 == "4,2,0" && d7 == "3,3,0") {
      Q[zz] = 9; P[9] = $i;
    }
  }

  for(i = 1; i < sep; i++) {
    zz = ch2bin($i);
    d3 = cmp($i, P[3]);
    d7 = cmp($i, P[7]);
    d8 = cmp($i, P[8]);
    d9 = cmp($i, P[9]);
    if (d3 == "4,2,1" && d8 == "6,0,1" && d9 == "5,1,1") {
      Q[zz] = 0; P[0] = $i;
    }
    if (d3 == "4,2,1" && d7 == "2,4,1") {
      Q[zz] = 6; P[6] = $i;
    }
  }

  for(i = 1; i < sep; i++) {
    zz = ch2bin($i);
    d4 = cmp($i, P[4]);
    d6 = cmp($i, P[6]);
    if (d4 == "3,2,1" && d6 == "5,0,1") {
      Q[zz] = 5; P[5] = $i;
    }
  }

  for(i = 1; i < sep; i++) {
    zz = ch2bin($i);
    d5 = cmp($i, P[5]);
    if (d5 == "3,2,2") {
      Q[zz] = 2; P[2] = $i;
    }
  }

  j = 0;
  for(i = NF; i > sep; i--) {
    total += (10^j) * Q[ch2bin($i)]; j++
  }
}

END { print total; }
