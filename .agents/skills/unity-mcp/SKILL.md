---
name: unity-mcp
description: OPTIONAL — only for Unity projects that explicitly use CoplayDev/unity-mcp. Do NOT trigger this skill automatically for general Unity questions, C# help, or game dev tasks unrelated to MCP setup. Use ONLY when the user explicitly asks to set up, configure, or troubleshoot the unity-mcp MCP server connection (e.g. "skonfiguruj unity-mcp", "set up unity MCP", "unity-mcp nie działa", "połącz Claude z Unity przez MCP"). Covers: installation (Unity package + Python server), Claude Code config (.mcp.json), session startup protocol, troubleshooting Windows-specific issues (case mismatch, deferred tools, WebSocket false alarms), and tool usage patterns (43 tools across 10 groups).
---

# unity-mcp

Connect Claude Code to Unity Editor via [CoplayDev/unity-mcp](https://github.com/CoplayDev/unity-mcp) — a FastMCP-based bridge with 43 tools across 10 groups.

## When to use this skill

- First-time setup of unity-mcp in a Unity project
- Troubleshooting a broken MCP ↔ Unity connection
- Using unity-mcp tools during feature implementation
- Multi-instance routing (multiple Unity editors open simultaneously)

For spec-driven implementation after the connection is live, continue with `implement-specs`.

---

## Part A — Installation (Unity side)

### Step 1: Add the Unity package

Open the Unity project. Then:

**Window → Package Manager → + (top-left) → Add package from git URL**

Paste:
```
https://github.com/CoplayDev/unity-mcp.git?path=/MCPForUnity#main
```

Wait for Unity to resolve and compile. Watch the bottom status bar — it must say "Done" with no errors in the Console.

**Common failure points:**
- Git is not installed or not in PATH → install Git for Windows, restart Unity
- Firewall blocks GitHub HTTPS → use a VPN or corporate proxy bypass
- Unity shows "package not found" → try pinning a version: `...#v9.7.1` instead of `#main`

### Step 2: Auto-configure Claude Code

After the package compiles:

**Window → MCP for Unity → Configure All Detected Clients**

This writes the MCP server entry into `.claude/settings.json` (or equivalent for other clients). Verify it appeared:

```json
{
  "mcpServers": {
    "UnityMCP": {
      "command": "uvx",
      "args": ["--from", "mcpforunityserver", "mcp-for-unity", "--transport", "stdio"]
    }
  }
}
```

If the auto-configure did not run or failed, add this block manually to the project's `.claude/settings.json`.

---

## Part B — Prerequisites (Python side)

**Check before proceeding:**

```powershell
python --version   # must be 3.10+
uv --version       # must exist
```

If `uv` is missing:
```powershell
pip install uv
# or (recommended)
irm https://astral.sh/uv/install.ps1 | iex
```

Restart the terminal after installing uv so PATH updates.

---

## Part C — Transport mode selection

Choose based on your use case:

| Mode | When to use | Server startup needed? |
|------|-------------|----------------------|
| **stdio** | Local dev, single Claude session | No — uvx starts it automatically |
| **HTTP** | Shared server, team, multi-instance | Yes — start manually before Claude |

### stdio (recommended for local solo dev)

Settings.json entry (written by auto-configure):
```json
"UnityMCP": {
  "command": "uvx",
  "args": ["--from", "mcpforunityserver", "mcp-for-unity", "--transport", "stdio"]
}
```

Claude Code starts the Python process automatically when needed. No manual server startup required.

### HTTP (for multi-instance or team use)

Start the server once manually:
```powershell
uvx --from mcpforunityserver mcp-for-unity --transport http --http-url http://127.0.0.1:8080
```

> **Windows: use `127.0.0.1`, not `localhost`.** On Windows, `localhost` may resolve to IPv6 `[::1]`, which the Unity plugin doesn't connect to. Always use the explicit IPv4 address.

**Where to put the config — use `.mcp.json` in the project root, not `~/.claude.json`:**

`~/.claude.json` is keyed by the path string used when the project was *first* opened. If the case changed (e.g. `C:/UNITY/` vs `c:/UNITY/`) Claude Code matches a different key and silently loads an empty `mcpServers: {}`. `.mcp.json` is loaded by path content, not key matching, and is immune to this.

Create `.mcp.json` in the project root:
```json
{
  "mcpServers": {
    "UnityMCP": {
      "type": "http",
      "url": "http://127.0.0.1:8080/mcp"
    }
  }
}
```

The `.claude/settings.json` entry written by auto-configure is a fallback only — validate its JSON before relying on it (see Troubleshooting).

---

## Part D — Verification

After configuration, verify the connection:

1. Restart Claude Code (close and reopen the project)
2. Check that `UnityMCP` appears in the active MCP servers list
3. In Claude Code, ask: "List available unity-mcp tools" — you should see 43 tools

**In Unity Editor:**

**Window → MCP for Unity** — the window should show the connection status.

### Troubleshooting checklist

| Symptom | Cause | Fix |
|---------|-------|-----|
| `uvx: command not found` | uv not in PATH | Restart terminal, or use full path to uvx |
| `Connection refused` (HTTP mode) | Server not running | Start the server manually first |
| Tools show as `undefined` | Version mismatch | Pin matching versions: `#v9.7.1` + `mcpforunityserver==9.7.1` |
| Unity package compiles but tools missing | Auto-configure failed | Add `.mcp.json` block manually (see Part C HTTP section) |
| `spawn uvx ENOENT` on Windows | uvx not found by Node/Claude Code process | Add uv to System PATH, not just user PATH; restart machine |
| Python server crashes on start | Python < 3.10 | `py -3.10 -m ...` or install Python 3.10+ |
| Tools work but Unity doesn't respond | Unity Editor not focused / in play mode | Exit Play Mode, click on Unity Editor window |
| UnityMCP missing despite config in `~/.claude.json` | Case mismatch in path key (e.g. `C:/UNITY/` vs `c:/UNITY/`) | Switch to `.mcp.json` in project root — immune to case matching |
| `.claude/settings.json` silently ignored | Trailing comma or syntax error in JSON | Validate: `node -e "JSON.parse(require('fs').readFileSync('.claude/settings.json','utf8'))"` |
| `[WebSocket] Connection failed` in Unity console | Plugin started before Python server was up | Check server log for `Plugin registered: <Name> (<hash>)` — if present, connection is fine; clear console with `read_console(action: "clear")` |
| `InputValidationError` on first MCP tool call | UnityMCP tools are deferred — schema not loaded | Run `ToolSearch` first (see Session startup protocol below) |

---

## Session startup protocol (HTTP transport, VSCode extension)

In Claude Code VSCode extension, UnityMCP tools are **deferred** — their schemas are not loaded until explicitly requested. Calling a tool directly gives `InputValidationError`. Run this protocol at the start of every session:

**Step 1 — Load tool schemas**
```
ToolSearch(query: "select:mcp__UnityMCP__set_active_instance,mcp__UnityMCP__read_console,mcp__UnityMCP__manage_scene")
```
Add any other tools you'll need in this session to the same `select:` list.

**Step 2 — Target the correct Unity instance**

The instance name and hash come from the Python server log on startup:
```
Plugin registered: DarkEdenDigital (19cd6b766bd526c0)
```
Call:
```
set_active_instance("DarkEdenDigital@19cd6b766bd526c0")
```
You can use a prefix of the hash if it's unique.

**Step 3 — Drain historical WebSocket errors**

Unity logs `[WebSocket] Connection failed` for every reconnect attempt before the server was ready. These are historical — not current failures. Filter them out:
```
read_console(types: ["error"])
```
If the only errors are WebSocket connection messages, the integration is healthy. Clear the console:
```
read_console(action: "clear")
```

**Step 4 — Confirm active scene**
```
manage_scene(action: "get_active")
```
This verifies end-to-end communication. If it returns a scene name, you're ready to work.

---

## Tool Groups

Unity-mcp has 43 tools in 10 groups. Activate only what you need to reduce prompt size and cost.

| Group | Key Tools | Enable when |
|-------|-----------|-------------|
| **Core** (always on) | ManageScene, ManageScript, ManageAsset, FindGameObjects, ManageComponents, BatchExecute, ExecuteMenuItem, ReadConsole, RunTests, RefreshUnity | Always |
| **GameObjects** | GameObject-specific operations | Hierarchy work |
| **Prefabs** | Prefab create/edit/unpack | Prefab system work |
| **Graphics** | ManageMaterial, ManageShader, ManageTexture | Visual / rendering work |
| **Animation** | Animator, clips, parameters | Character / UI animation |
| **VFX** | Particle systems, VFX Graph | Effects work |
| **UI** | ManageUI, canvas operations | UI layout work |
| **Cameras** | Camera setup, render textures | Camera / viewport work |
| **Physics** | Colliders, rigidbody, layers | Physics setup |
| **ProBuilder** | 3D mesh editing | ProBuilder geometry |
| **Build** | ManageBuild, CI integration | Build automation |
| **Profiler** | Performance capture | Optimization passes |

Configure active groups: **Window → MCP for Unity → Tool Groups**

---

## Workflow: using unity-mcp tools

### Read before write

Always inspect current state before modifying:

```
FindGameObjects — what exists in the hierarchy
ManageScene (read) — scene list
ReadConsole — any pre-existing errors
ManageAsset (list) — existing assets
```

### Script-first order

1. Write or update `.cs` files (via Edit/Write tools or IDE)
2. `RefreshUnity` — triggers recompile
3. `ReadConsole` — check for compile errors
4. Fix errors → repeat until console is clean
5. Only then: modify GameObjects, add components

### Batch operations

Prefer `BatchExecute` when doing 3+ operations on GameObjects — it is faster and optionally atomic:

```
BatchExecute([
  ManageComponents("Player", add="PlayerController"),
  ManageComponents("Player", add="Rigidbody"),
  ManageComponents("Enemy", add="EnemyAI"),
])
```

### Roslyn validation (ManageScript)

`ManageScript` validates C# via Roslyn before saving. If validation returns errors, fix them before writing to disk. This prevents Unity from entering a broken compile state.

### ExecuteMenuItem escape hatch

For operations without a dedicated tool (bake lightmaps, run a custom editor script, trigger a build step):

```
ManageEditor("unity://menu-items")  — list all menu paths
ExecuteMenuItem("Assets/Bake Lightmaps")
```

---

## Multi-Instance Routing

When multiple Unity projects are open simultaneously:

1. Use HTTP transport
2. Each Unity instance registers with the server on startup — the server logs: `Plugin registered: <ProjectName> (<hash>)`
3. Target a specific instance with the full `Name@hash` format:
   ```
   set_active_instance("DarkEdenDigital@19cd6b766bd526c0")
   ```
   A unique prefix of the hash also works: `set_active_instance("DarkEdenDigital@19cd6b")`

The hash is stable per Editor session but changes on Unity restart. Always get it from the current server log.

Enable per-instance routing for team use: start the server with `--http-remote-hosted` and manage sessions via API key per client.

---

## Custom Tools

Register project-specific tools with the `[McpForUnityTool]` C# attribute:

```csharp
[McpForUnityTool("my_custom_tool", "Description for the LLM")]
public static ToolResult MyCustomTool(MyParams p) { ... }
```

Decorate on any static editor class. Tools are discovered via reflection and appear in the MCP tool list automatically. Use `--project-scoped-tools` to keep them isolated to the active project.

---

## Related Skills

- `unity-implement` — spec-driven implementation using mcp-unity (CoderGamester variant)
- `implement-specs` — language-agnostic spec implementation parent
- `write-tech-spec` — write TECH.md before starting implementation

## Tool reference

See `references/tools.md` for the complete list of all 43 tools with descriptions and parameters.
