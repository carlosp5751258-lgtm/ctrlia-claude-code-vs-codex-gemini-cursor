#!/usr/bin/env bash
# bench.sh — one run: bench.sh <tool> <task> <repetition>
# Tools: claude | codex | cursor | agy. Tasks: T1 | T2 | T3.
# Requires: the test repo in $FIXTURE (fixed commit) and the hidden tests in $HIDDEN_TESTS (outside the repo).
set -euo pipefail
[ $# -eq 3 ] || { echo "usage: $0 <tool> <task> <repetition>" >&2; exit 2; }
H=$1; T=$2; N=$3
FIXTURE=${FIXTURE:?set FIXTURE}; HIDDEN_TESTS=$(cd "${HIDDEN_TESTS:?set HIDDEN_TESTS}" && pwd)
OUT=$PWD/${OUT:-results}; mkdir -p "$OUT"; LOG=$OUT/$H-$T-$N
W=$(mktemp -d); trap 'rm -rf "$W"' EXIT
git clone -q "$FIXTURE" "$W/repo"; cd "$W/repo"
PROMPT=$(cat "tareas/$T.md")
rc=0; t0=$(date +%s.%N)
case $H in
  claude) claude -p "$PROMPT" --output-format json --permission-mode acceptEdits \
            --allowedTools "Bash(python3 -m pytest *)" --max-budget-usd 2 \
            --no-session-persistence > "$LOG.json" || rc=$? ;;
  codex)  codex exec "$PROMPT" > "$LOG.txt" || rc=$? ;;   # JSON and sandbox flags: confirm with `codex exec --help` on the test day
  cursor) agent -p --force --output-format json "$PROMPT" > "$LOG.json" || rc=$? ;;
  agy)    echo "Antigravity CLI: headless mode not verified; see its Headless mode page" >&2; exit 2 ;;
  *)      echo "unknown tool: $H" >&2; exit 2 ;;
esac
t1=$(date +%s.%N)
# the diff before copying in the hidden tests, so they don't count as the agent's changes
git diff --stat HEAD > "$LOG.diff.txt"; git status --porcelain >> "$LOG.diff.txt"
python3 -m pytest -q tests --tb=no > "$LOG.visible.txt" 2>&1 || true
cp -r "$HIDDEN_TESTS" ./hidden_tests
python3 -m pytest -q hidden_tests --tb=no > "$LOG.hidden.txt" 2>&1 || true
echo "$H,$T,$N,$(python3 -c "print(round($t1 - $t0, 2))"),$rc" >> "$OUT/times.csv"
