#!/usr/bin/env -S awk -f

BEGIN { mx = 0; my = 0; }

/fold along y/ {
  split($0, y, "=");
  row = y[2];

  for (r = 0; r <= row; r++) {
    for (c = 0; c <= mx; c++) {
      map[row - r][c] += map[row + r][c];
    }
  }
  my = row;

  for (r = 0; r <= my; r++) {
    for (c = 0; c <= mx; c++) {
      count += map[r][c] > 0;
    }
  }
  print count; exit;
}

/fold along x/ {
  split($0, x, "=");
  col = x[2];

  for (r = 0; r <= my; r++) {
    for (c = 0; c <= col; c++) {
      map[r][col - c] += map[r][col + c];
    }
  }
  mx = col;

  for (r = 0; r <= my; r++) {
    for (c = 0; c <= mx; c++) {
      count += map[r][c] > 0;
    }
  }
  print count; exit;
}

/^.+$/ {
  split($0, coords, ",");
  map[coords[2]][coords[1]] = 1;
  my = my > coords[2] ? my : coords[2];
  mx = mx > coords[1] ? mx : coords[1];
}
