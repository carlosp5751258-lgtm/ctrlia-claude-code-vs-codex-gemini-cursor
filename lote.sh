#!/usr/bin/env bash
# lote.sh — todas las herramientas × T1-T3 × 5 repeticiones, intercaladas
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p resultados
for n in 1 2 3 4 5; do
  for t in T1 T2 T3; do
    for h in ${HERRAMIENTAS:-claude codex cursor agy}; do
      ./bench.sh "$h" "$t" "$n" || echo "$h,$t,$n,,fallo" >> resultados/tiempos.csv
    done
  done
done
