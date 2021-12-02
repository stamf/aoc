#!/usr/bin/env bash

awk 'BEGIN { x = 0; y = 0; }

$1 == "forward" { x += $2; }
$1 == "down"   { y += $2; }
$1 == "up"     { y -= $2; }

END { print x * y; }' < input
