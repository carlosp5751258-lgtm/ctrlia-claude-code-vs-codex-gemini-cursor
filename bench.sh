#!/usr/bin/env bash
# bench.sh — una ejecución: bench.sh <herramienta> <tarea> <repeticion>
# Herramientas: claude | codex | cursor | agy. Tareas: T1 | T2 | T3.
# Requiere: el repo de prueba en $FIXTURE (commit fijo) y las pruebas ocultas en $OCULTAS (fuera del repo).
set -euo pipefail
[ $# -eq 3 ] || { echo "uso: $0 <herramienta> <tarea> <repeticion>" >&2; exit 2; }
H=$1; T=$2; N=$3
FIXTURE=${FIXTURE:?define FIXTURE}; OCULTAS=$(cd "${OCULTAS:?define OCULTAS}" && pwd)
OUT=$PWD/${OUT:-resultados}; mkdir -p "$OUT"; LOG=$OUT/$H-$T-$N
W=$(mktemp -d); trap 'rm -rf "$W"' EXIT
git clone -q "$FIXTURE" "$W/repo"; cd "$W/repo"
PROMPT=$(cat "tareas/$T.md")
rc=0; t0=$(date +%s.%N)
case $H in
  claude) claude -p "$PROMPT" --output-format json --permission-mode acceptEdits \
            --allowedTools "Bash(python3 -m pytest *)" --max-budget-usd 2 \
            --no-session-persistence > "$LOG.json" || rc=$? ;;
  codex)  codex exec "$PROMPT" > "$LOG.txt" || rc=$? ;;   # flags de JSON y sandbox: confirmar con `codex exec --help` el día de la prueba
  cursor) agent -p --force --output-format json "$PROMPT" > "$LOG.json" || rc=$? ;;
  agy)    echo "Antigravity CLI: modo headless sin verificar; ver su página Headless mode" >&2; exit 2 ;;
  *)      echo "herramienta desconocida: $H" >&2; exit 2 ;;
esac
t1=$(date +%s.%N)
# el diff antes de copiar las pruebas ocultas, para que no cuenten como cambios del agente
git diff --stat HEAD > "$LOG.diff.txt"; git status --porcelain >> "$LOG.diff.txt"
python3 -m pytest -q tests --tb=no > "$LOG.visibles.txt" 2>&1 || true
cp -r "$OCULTAS" ./tests_ocultos
python3 -m pytest -q tests_ocultos --tb=no > "$LOG.ocultas.txt" 2>&1 || true
echo "$H,$T,$N,$(python3 -c "print(round($t1 - $t0, 2))"),$rc" >> "$OUT/tiempos.csv"
