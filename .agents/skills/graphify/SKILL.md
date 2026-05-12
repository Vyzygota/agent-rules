---
name: graphify
description: Build a queryable knowledge graph from an entire codebase (code, docs, PDFs, images, video) using Tree-sitter + Claude subagents. Use when the agent needs to understand cross-file relationships, find "god nodes", or reduce token usage by querying the graph instead of searching raw files. Installs a PreToolUse hook so Claude consults the graph before every Glob/Grep call.
---

# graphify

## Core Concept

Graphify turns a repository into a **knowledge graph** — a network of functions, classes, imports, and call relationships that the agent can query instead of reading raw files.

Without a graph, the agent searches files linearly: Glob → Grep → Read, consuming tokens proportional to the codebase size. With a graph, the agent answers "what connects `AuthService` to the database?" in a single query against a pre-built index.

Key properties:
- **Zero network calls in Pass 1** — AST extraction is deterministic, local, offline
- **No code sent externally** — only docs/images/video summaries use the Claude API (your own credentials)
- **Provenance tracking** — every relationship is tagged EXTRACTED, INFERRED, or AMBIGUOUS with confidence metadata
- **20 languages** via Tree-sitter: Python, JS, TS, Go, Rust, Java, C, C++, Ruby, C#, Kotlin, Scala, PHP, Swift, Lua, Zig, PowerShell, Elixir, Objective-C, Julia

---

## Three-Pass Architecture

| Pass | Input | Engine | Network |
|---|---|---|---|
| 1 — AST extraction | Source code | Tree-sitter + NetworkX + Leiden clustering | None |
| 2 — Audio transcription | Video / audio files | faster-whisper (local) | None |
| 3 — Semantic extraction | Docs, PDFs, images, transcripts | Claude subagents (your API key) | Anthropic API only |

Run only Pass 1 if you want zero LLM cost and zero network. Passes 2–3 are opt-in.

---

## Installation

### Prerequisites

- Python 3.10+
- `uv` or `pipx`

### Install Graphify

```bash
uv tool install graphifyy
# or
pipx install graphifyy
```

### Integrate with Claude Code

```bash
graphify claude install
# or equivalently:
graphify claude install
```

This does two things:
1. Writes a directive to `CLAUDE.md` telling Claude to check `GRAPH_REPORT.md` before searching files
2. Adds a `PreToolUse` hook in `.claude/settings.json` that fires before every `Glob` and `Grep` call

The hook message Claude sees before each file search:
> "graphify: Knowledge graph exists. Read GRAPH_REPORT.md for god nodes and community structure before searching raw files."

---

## Workflow

### 1. Build the graph

```bash
# Build for the entire current directory
/graphify .

# Rebuild only changed files (incremental — fast on large repos)
/graphify ./docs --update
```

Outputs go to `graphify-out/`:

| File | Purpose |
|---|---|
| `graph.html` | Interactive visualization — click nodes, filter, search, zoom/pan |
| `GRAPH_REPORT.md` | Human-readable synthesis: god nodes, surprising connections, suggested queries |
| `graph.json` | Full queryable graph data for programmatic use |
| `sha256-cache/` | Content-addressed cache — unchanged files are never re-extracted |

### 2. Query the graph

```bash
# Natural language query
graphify query "what connects auth to the database?"

# Shortest path between two nodes
graphify path "UserService" "DatabasePool"

# Explain a component's role
graphify explain "RateLimiter"
```

### 3. Generate architecture docs

```bash
# Self-contained Mermaid call-flow HTML (auto-regenerates on rebuild)
graphify export callflow-html
```

### 4. Team / CI integration

```bash
# Install a git hook — auto-rebuilds graph on every commit
graphify hook install

# Merge two graphs (monorepo, multi-service)
graphify merge-graphs service-a.json service-b.json
```

### 5. Headless extraction (docs / media only)

```bash
# Extract docs with a specific backend
graphify extract ./docs --backend gemini

# Parallel extraction (scales to large doc sets)
graphify extract ./docs --max-workers 16
```

---

## Using the Graph as an Agent

After `graphify claude install`, Claude automatically checks the graph before file searches. You can also query it explicitly:

1. **Read `GRAPH_REPORT.md` first** — it lists god nodes (highest-connectivity concepts) and community clusters. This tells you which modules are central before you read a single source file.
2. **Use `graphify query`** to answer cross-file questions without Glob/Grep.
3. **Use `graphify path`** to trace how two components connect — faster than reading all intermediate files.
4. **Use `graphify explain`** when you encounter an unfamiliar class or function.

---

## Best Practices

- **Build once, query many times.** Run `/graphify .` at the start of a session, then use `--update` for incremental rebuilds.
- **Start with Pass 1 only** — AST extraction is instant and free. Add Pass 3 (semantic) only when docs or images carry information that code does not.
- **God nodes are your entry points.** GRAPH_REPORT.md lists the most-connected nodes — start there when exploring an unfamiliar codebase.
- **Keep `graphify-out/` in `.gitignore`** unless the team wants to share the built graph (large binary).
- **The git hook (`graphify hook install`) is the lowest-friction way to keep the graph current** in active development.
- **For monorepos:** build per-service graphs and merge them. Do not build one graph over the entire monorepo at once — the god-node signal gets diluted.

---

## Updating `init-project`

When initializing a project that will use Graphify, add to `skills-lock.json`:

```json
"graphify": {
  "source": "vyzygota/agent-rules",
  "sourceType": "github",
  "skillPath": ".agents/skills/graphify/SKILL.md"
}
```

And run after project init:

```bash
graphify claude install
echo "graphify-out/" >> .gitignore
```

---

## Source

- GitHub: https://github.com/safishamsi/graphify
- Website: https://graphify.net/

---

## Related Skills

- `init-project` — bootstrap; run `graphify install` as a post-init step
- `spec-driven-implementation` — use `graphify query` during context-gathering phase instead of raw Grep
- `diagnose-ci-failures` — use `graphify path` to trace which modules a failing test touches
- `warp-watch` — check for new Graphify releases when syncing upstream patterns
