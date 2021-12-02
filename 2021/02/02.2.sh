#!/usr/bin/env bash

awk 'BEGIN { x = 0; y = 0; a = 0; }

$1 == "forward" { x += $2; y += a * $2; }
$1 == "down"   { a += $2; }
$1 == "up"     { a -= $2; }

END { print x * y; }' < input
