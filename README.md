# Claude Code vs Codex vs Gemini vs Cursor: banco de pruebas

🇬🇧 [Read in English](README.en.md)

Scripts para comparar cuatro agentes de programación de terminal (Claude Code, Codex CLI, Antigravity CLI o Gemini CLI
y Cursor CLI) con **la misma tarea**, pruebas ocultas que el agente no ve y 5 repeticiones por herramienta y tarea.

> **Metodología lista; resultados pendientes.** Todavía no hemos ejecutado la prueba completa. La tabla de
> `comparativa.md` solo tiene datos oficiales; las filas de resultados están vacías a propósito.

Página con la metodología completa: [ctrlia.dev (ES)](https://ctrlia.dev/recetas/claude-code-vs-codex-gemini-cursor.html) ·
[ctrlia.dev (EN)](https://ctrlia.dev/en/recetas/claude-code-vs-codex-gemini-cursor.html)

## Qué incluye

- `bench.sh`: una ejecución (`bench.sh <herramienta> <tarea> <repeticion>`). Clona el repositorio de prueba en una carpeta
  temporal, lanza la herramienta sin interfaz, mide el tiempo, guarda el diff y ejecuta las pruebas visibles y ocultas.
- `lote.sh`: todas las herramientas × T1-T3 × 5 repeticiones, intercaladas.
- `tareas/T1.md`, `T2.md`, `T3.md`: el texto de cada tarea, igual para todas las herramientas (borrador: el repositorio de
  prueba de unas 600 líneas en Python todavía no está publicado).
- `comparativa.md` / `comparativa.en.md`: la tabla comparativa.

## Cómo usarlo

Necesitas `git`, Python 3 con `pytest` y las herramientas que quieras comparar ya instaladas y con sesión iniciada.

```bash
git clone https://github.com/carlosp5751258-lgtm/ctrlia-claude-code-vs-codex-gemini-cursor.git
cd ctrlia-claude-code-vs-codex-gemini-cursor
export FIXTURE=/ruta/a/tu-repo-de-prueba    # repositorio git con tareas/T1.md..T3.md y tests/
export OCULTAS=/ruta/a/pruebas-ocultas      # carpeta FUERA del repositorio de prueba
./bench.sh claude T1 1                       # una ejecución
HERRAMIENTAS=claude ./lote.sh                # solo Claude Code: 15 ejecuciones
./lote.sh                                    # las cuatro: 60 ejecuciones
```

Los resultados quedan en `resultados/`: el JSON o texto de cada herramienta, el diff, la salida de las pruebas visibles y
ocultas, y `tiempos.csv` con `herramienta,tarea,repeticion,segundos,codigo_salida`.

**Ojo con el gasto:** cada ejecución de Claude Code tiene un límite de 2 USD (`--max-budget-usd 2`) y consume el margen de
tu plan. Las otras herramientas no tienen límite en el script: revisa su configuración antes de lanzar el lote.
El modo headless de Antigravity CLI (`agy`) no está verificado y el script lo marca como fallo.

## Probado

- `bash -n bench.sh lote.sh` y una ejecución completa con un `claude` simulado (sin llamadas reales) sobre un repositorio
  de prueba mínimo: crea el diff, las salidas de pruebas y la fila de `tiempos.csv`.
- Los flags de `claude -p` se comprobaron con Claude Code **2.1.316**. Codex CLI, Cursor CLI y Antigravity CLI no se han
  instalado ni probado.

## Licencia

MIT. Copyright (c) 2026 Ctrl+IA (Carlos P.). Ver [LICENSE](LICENSE).
