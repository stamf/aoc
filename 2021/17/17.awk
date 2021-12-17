#!/usr/bin/env -S awk -f

{
  xrange = substr($3, 3, length($3) - 3);
  yrange = substr($4, 3);

  split(xrange, xs, ".");
  split(yrange, ys, ".");

  tx0 = xs[1];
  tx1 = xs[3];
  ty0 = ys[3];
  ty1 = ys[1];
}

function check(vx, vy, cx, cy, h) {
  cx = 0; cy = 0; h = 0;
  while (cx <= tx1 && cy >= ty1 && !(cx < tx0 && vx == 0)) {
    cx += vx;
    cy += vy;
    vx -= vx > 0 ? 1 : 0;
    vy -= 1;
    h   = cy > h ? cy : h;

    if (cx >= tx0 && cx <= tx1 && cy >= ty1 && cy <= ty0) {
      num++;
      return h;
    }
  }
}

function abs(x) { return x < 0 ? -x : x; }

END {
  max = 0; num = 0;
  for (x = 1; x <= tx1; x++) {
    for (y = -abs(ty1); y <= abs(ty1); y++) {
      height = check(x, y);
      max = height > max ? height : max;
    }
  }

  print "max height:", max;
  print "total traj:", num;
}
