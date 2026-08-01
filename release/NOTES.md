## GDMetrics for Godot 3 — v0.1.3

Early release / pre-stable. Breaking changes may still occur before v1.0.

### Highlights
- Line-continuation (`\`), match-arm scoring, ternary/`&&`/`||` handling
- Tokenizer fixes for `$` paths, annotations, triple-string trail/`\` cases
- External project host CLI (`tests/analyze_external.gd`)
- Edge-case fixtures + corpus validation against real Godot 3 projects (`D:\test-3`: 21/21, 0 soft token errors)

### Install
1. Download `gdmetrics-v0.1.3.zip`
2. Copy `addons/gdscript_complexity/` into your Godot 3 project
3. Project → Project Settings → Plugins → enable **GDScript Complexity Analyzer**

### Docs
See `README.md`, `docs/USER_GUIDE.md`, `docs/EDGE_CASES.md`, and `docs/COMPATIBILITY.md` in the zip.
