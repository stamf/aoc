#!/usr/bin/env bash

filter() {
  local def="$1"
  local cmp="$2"
  local nums="$3"
  local fld=1
  local rgx
  while [ $(grep -c . <<< "$nums") -gt 1 ]; do
    bit="$(cut -c"$fld" <<< "$nums" | sort | uniq -c | awk '
      NR == 1 { n = $1; x = $2; }
      NR == 2 { print n == $1 ? '$def' : ($1 '$cmp' n ? $2 : x) }')"

    rgx+="${bit}"

    nums="$(grep "^${rgx}" <<< "$nums")"
    let fld++
  done

  echo "$nums" | sed 's/\t//g'
}

a="$(filter "1" ">" "$(< input)")"
b="$(filter "0" "<" "$(< input)")"

echo "$((2#$a))" "$((2#$b))" "$((2#$a * 2#$b))"
