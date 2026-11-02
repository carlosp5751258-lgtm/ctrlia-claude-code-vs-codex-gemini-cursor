#!/usr/bin/env bash
# lote.sh — all tools × T1-T3 × 5 repetitions, interleaved
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p results
for n in 1 2 3 4 5; do
  for t in T1 T2 T3; do
    for h in ${TOOLS:-claude codex cursor agy}; do
      ./bench.sh "$h" "$t" "$n" || echo "$h,$t,$n,,failed" >> results/times.csv
    done
  done
done
