#!/usr/bin/env bash

rm xx*.* 2>/dev/null

csplit -s --suppress-matched input '/^$/' '{*}'

sed 's/,/\n/g' xx00 > numbers
rm -f xx00

createLines() {
  for((i = 1; i <= 5; i++)) {
    sed -i 's/ \+/ /g;s/^ //' "$1"
    sed -nE "${i}s/ /\n/gp"   "$1" > "${1}.r${i}"
    cut -f"$i" -d' '          "$1" > "${1}.c${i}"
  }
}

for board in xx*; do createLines "$board"; done

for((i = 1; i <= $(wc -l < numbers); i++)) {
  grep -c -wF -f <(head -n $i numbers) xx*.* \
    | awk -F: -v i=$i '$2 == 5 { print i, $1 }'
} | sed 's/\..*$//' \
  | awk '!seen[$2]++' \
  | tail -n 1 \
  | ( read line board;

      a=$(sed -n "${line}p" numbers);
      b=$(sort -u ${board}.* \
        | grep -vwFf <(head -n $line numbers) \
        | awk '{n += $1} END {print n}')

      echo $a $b $((a * b))
    )
