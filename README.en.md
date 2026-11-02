# Claude Code vs Codex vs Gemini vs Cursor: test bench

🇪🇸 [Leer en español](README.md): the Spanish version is at the repository root and in README.md; the English files are in `en/`.

Scripts to compare four terminal coding agents (Claude Code, Codex CLI, Antigravity CLI or Gemini CLI and Cursor CLI)
on **the same task**, with hidden tests the agent can't see and 5 repetitions per tool and task.

> **Methodology ready; results pending.** We haven't run the full test yet. The table in `en/comparativa.md` only has
> official data; the result rows are empty on purpose.

Page with the full methodology: [ctrlia.dev (EN)](https://ctrlia.dev/en/recetas/claude-code-vs-codex-gemini-cursor.html) ·
[ctrlia.dev (ES)](https://ctrlia.dev/recetas/claude-code-vs-codex-gemini-cursor.html)

## What's included

All paths are inside `en/`.

- `bench.sh`: one run (`bench.sh <tool> <task> <repetition>`). Clones the test repository into a temporary folder,
  runs the tool headless, measures the time, saves the diff and runs the visible and hidden tests.
- `lote.sh`: all tools × T1-T3 × 5 repetitions, interleaved.
- `tareas/T1.md`, `T2.md`, `T3.md`: the text of each task, the same for every tool (draft: the ~600-line
  Python test repository isn't published yet).
- `comparativa.md`: the comparison table.

## How to use it

You need `git`, Python 3 with `pytest`, and the tools you want to compare already installed and signed in.

```bash
git clone https://github.com/carlosp5751258-lgtm/ctrlia-claude-code-vs-codex-gemini-cursor.git
cd ctrlia-claude-code-vs-codex-gemini-cursor/en
export FIXTURE=/path/to/your-test-repo       # git repository with tareas/T1.md..T3.md and tests/
export HIDDEN_TESTS=/path/to/hidden-tests    # folder OUTSIDE the test repository
./bench.sh claude T1 1                        # one run
TOOLS=claude ./lote.sh                        # Claude Code only: 15 runs
./lote.sh                                     # all four: 60 runs
```

Results go to `en/results/`: each tool's JSON or text output, the diff, the visible and hidden test output, and
`times.csv` with `tool,task,repetition,seconds,exit_code`.

**Mind the spend:** each Claude Code run is capped at 2 USD (`--max-budget-usd 2`) and uses your plan's allowance. The
other tools have no cap in the script: check their settings before running the batch. Antigravity CLI's (`agy`) headless
mode isn't verified and the script marks it as a failure.

## Tested

- `bash -n bench.sh lote.sh` and a full run with a simulated `claude` (no real calls) on a minimal test repository: it
  creates the diff, the test outputs and the `times.csv` row (Spanish and `en/` versions).
- The `claude -p` flags were checked with Claude Code **2.1.316**. Codex CLI, Cursor CLI and Antigravity CLI have not
  been installed or tested.

## License

MIT. Copyright (c) 2026 Ctrl+IA (Carlos P.). See [LICENSE](LICENSE).
