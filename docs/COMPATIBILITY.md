# Compatibility Matrix and Version-Specific Limitations

This repository (**gdmetrics-g3**) targets **Godot 3.x only**. For Godot 4.x, use [gdmetrics-g4](https://github.com/JaponBaligi/gdmetrics-g4).

## Supported Versions

| Godot Version | Support Level | CLI Mode | Editor Plugin | Annotations | Confidence Cap |
|--------------|---------------|----------|---------------|-------------|---------------|
| 3.0 - 3.4    | Smoke Test    | +       | Limited       | Limited     | 0.90 max      |
| 3.5 (LTS)    | Full          | +       | +             | Limited     | 0.90 max      |

**Legend:**
- Fully supported
- Limited support (best-effort, may have issues)
- Not supported

## Godot 3.x Features

**Supported:**
- Cyclomatic Complexity (CC) calculation
- Cognitive Complexity (C-COG) calculation
- CLI mode analysis
- JSON / CSV report generation
- Basic editor plugin UI
- Annotation API surface via `set_error()` (availability depends on editor)

**Limitations:**
- `match` arms are supported (GDScript has no `case` keyword; arms are indented `pattern:` lines)
- Maximum confidence score capped at 0.90 (hard limit)
- Parser accuracy: 85-90% typical (best-effort)
- Some advanced syntax features may not be parsed correctly
- Editor annotations use older `set_error()` API (no severity levels); often unavailable in practice

**Known Issues:**
- Complex string interpolation may reduce parse accuracy
- Nested lambdas may not be fully analyzed
- Some edge cases in class inheritance may be missed

## Godot 4.x

Godot 4-only features (`await`, `when` guards, raw strings, `&`/`^` literals, uncapped confidence, editor annotations) live in [gdmetrics-g4](https://github.com/JaponBaligi/gdmetrics-g4).

## Parser Architecture Limitations

### Block-Oriented Parsing

The parser is **block-oriented and control-flow focused**, not a full AST:

- Parsed: Function boundaries, class definitions, control structures (`if`, `for`, `while`)
- Limited: Expression parsing (sufficient for complexity calculation only)
- Not Parsed: Full expression trees, type information, semantic analysis

### Rationale

Complexity metrics require control flow structure, not complete semantic understanding. The parser focuses on:
1. Identifying decision points (if, elif, for, while, logical operators)
2. Tracking nesting depth for C-COG calculation
3. Determining function and class boundaries

## Confidence Scoring

### Godot 3.x
- **Maximum**: 0.90 (hard cap)
- **Typical Range**: 0.75 - 0.90
- **Reason**: Best-effort support, known limitations

### Confidence Components

Confidence score is calculated from:
- Token coverage (40% weight)
- Indentation consistency (20% weight)
- Block balance (20% weight)
- Parse errors (20% weight)

## Editor Integration

- Uses `ScriptEditor.set_error(script_path, line, message)` API when available
- No severity levels (warnings prepended with "[WARNING]")
- Plugin lifecycle: `_enter_tree()`, `_exit_tree()`

## Smoke Test Requirements (Godot 3.0-3.4)

For versions 3.0-3.4, smoke tests verify:

**Required (Must Pass):**
- CLI mode works (`cli/analyze.gd` and `cli/ci_test.gd`)
- CC calculation works correctly
- Basic file analysis completes without crashes
- JSON report generation works

**Optional/Unsupported:**
- UI may be limited or unavailable
- Editor annotations may not work
- Advanced features may be disabled

**Success Criteria**: Core analysis functionality (CLI + CC) works; UI/annotations are optional.

## Testing Checklist

### Godot 3.5 (LTS) - Full Functionality
- [ ] Plugin loads without errors
- [ ] Dock panel displays correctly
- [ ] Analysis runs successfully
- [ ] Configuration dialog works
- [ ] Export functionality works
- [ ] CLI mode works

### Godot 3.0-3.4 - Smoke Tests
- [ ] CLI mode works
- [ ] CC calculation works
- [ ] Basic file analysis completes
- [ ] JSON report generation works
- [ ] No crashes during analysis

## Known Limitations Summary

1. **Parser Accuracy**: Best-effort. Typical accuracy: 85-90% (3.x)
2. **Complex Syntax**: String interpolation, nested lambdas may reduce accuracy
3. **Edge Cases**: Some unusual code patterns may not be parsed correctly
4. **Godot 3.x**: Maximum confidence cap of 0.90, best-effort support
5. **No Full AST**: Parser is block-oriented, not a complete semantic analyzer
6. **`match`**: Supported via arm detection (see `docs/EDGE_CASES.md`); default confidence weights emphasize parse errors

## Reporting Issues

When reporting compatibility issues, please include:
- Godot version (full version string from `Engine.get_version_info()`)
- Plugin version
- Error messages or unexpected behavior
- Sample code that triggers the issue (if applicable)
- Whether CLI mode or editor plugin is affected
