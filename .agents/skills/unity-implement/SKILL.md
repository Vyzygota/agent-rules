---
name: unity-implement
description: Implement an approved Unity feature from PRODUCT.md and TECH.md using mcp-unity tools (CoderGamester/mcp-unity). Orchestrates MCP calls in the correct order — scripts first, scene second, tests third. Use after specs are approved and Unity Editor is open with mcp-unity server running.
---

# unity-implement

Implement an approved Unity feature using mcp-unity MCP tools.

This skill extends `implement-specs` for Unity specifically. It defines the order and patterns for using mcp-unity tools — it does not duplicate tool documentation. Every operation named here maps to a concrete mcp-unity tool call.

## Prerequisites

- `PRODUCT.md` exists with numbered Behavior invariants
- `TECH.md` exists (for multi-module or architecturally significant features)
- Unity Editor is open
- mcp-unity server is running: **Tools > MCP Unity > Server Window** shows green "Server Online"
- mcp-unity is configured in `.claude/settings.json` (or equivalent for the active AI client)

## MCP Tool Reference

| Task | MCP Tool |
|---|---|
| Read scene state | `unity://scenes-hierarchy` resource |
| Read GameObject detail | `unity://gameobject/{id}` resource |
| Read console errors | `get_console_logs` or `unity://logs` |
| Read available tests | `unity://tests/{testMode}` |
| Create/update C# script | `update_gameobject` + file write via IDE, or `execute_menu_item` |
| Force recompile | `recompile_scripts` |
| Create GameObject | `update_gameobject` (creates if not exists) |
| Add/update component | `update_component` |
| Set transform | `set_transform` (position + rotation + scale in one call) |
| Reparent in hierarchy | `reparent_gameobject` |
| Create prefab | `create_prefab` |
| Create scene | `create_scene` |
| Load scene | `load_scene` |
| Save scene | `save_scene` |
| Create material | `create_material` → `assign_material` |
| Add UPM package | `add_package` |
| Run tests | `run_tests` |
| Batch operations | `batch_execute` |
| Trigger any menu item | `execute_menu_item` |

## Workflow

### 1. Read the specs

Read `PRODUCT.md` in full. Note every numbered Behavior invariant — these are your acceptance criteria.

Read `TECH.md`: which scripts change, which GameObjects are affected, which scenes are in scope, what the test plan says.

### 2. Inspect current Unity state

Before touching anything, read the current state:

```
unity://scenes-hierarchy          — what GameObjects exist right now
unity://assets                    — what assets are already in the project
unity://packages                  — are required packages installed?
unity://tests/EditMode            — which tests already exist
get_console_logs                  — any pre-existing errors to clear first
```

If required packages are missing, call `add_package` before proceeding.

### 3. Write scripts first

Scripts drive everything else (components, prefabs, scenes depend on compiled types). Always write and compile scripts before creating scene objects.

**Pattern:**
1. Write or update `.cs` files using the IDE (mcp-unity does not write script content directly — use `update_gameobject` → assign component name only after the type exists)
2. Call `recompile_scripts`
3. Call `get_console_logs` — filter for errors
4. If errors: fix scripts, `recompile_scripts` again
5. Repeat until console is clean

Do not proceed to scene setup until compilation is error-free.

### 4. Set up scenes and hierarchy

With scripts compiled, set up the scene. Use `batch_execute` whenever creating or modifying multiple GameObjects in one logical operation — it is significantly faster than individual calls.

```
// Example: create three GameObjects in one call
batch_execute([
  update_gameobject("Enemy_1", tag="Enemy", layer="Enemies"),
  update_gameobject("Enemy_2", tag="Enemy", layer="Enemies"),
  update_gameobject("Enemy_3", tag="Enemy", layer="Enemies"),
])
```

**Order within scene setup:**
1. Create parent GameObjects before children
2. Call `reparent_gameobject` to set hierarchy
3. Call `set_transform` for position/rotation/scale (one call per object, not three)
4. Call `update_component` to set serialized fields on MonoBehaviours
5. Call `create_material` → `assign_material` for visuals
6. Call `create_prefab` if the object should be a reusable asset
7. Call `save_scene` before running tests

### 5. Run tests and verify invariants

```
run_tests(testMode="EditMode")
run_tests(testMode="PlayMode")   // only when feature requires runtime behavior
```

Map each test result to a numbered Behavior invariant from `PRODUCT.md`:
- Passing test = invariant verified ✓
- Failing test = invariant not met → fix implementation, not the test

If a test fails: read the failure message from the result, trace back to which PRODUCT.md invariant it covers, fix the implementation, recompile, run tests again.

Do not mark a feature complete until every Behavior invariant from `PRODUCT.md` has a passing test or explicit justification why it cannot be tested automatically.

### 6. Update specs if implementation diverged

If implementation reveals the spec was wrong or incomplete:
- Update `PRODUCT.md` when behavior or edge cases changed
- Update `TECH.md` when architecture or test plan changed

Keep spec changes in the same commit as the code that caused them.

### 7. Save and report

Call `save_scene` on every modified scene.

Report status:
- Which PRODUCT.md invariants are covered by passing tests (by number)
- Which invariants need manual verification and why
- Any open questions or follow-up work

## Key Patterns

### Use batch_execute aggressively

Any time you would call the same tool more than twice in sequence, use `batch_execute` instead. It reduces round-trips and makes operations atomic (optional rollback on failure).

### Script-first, always

Never call `update_component` for a MonoBehaviour type that hasn't been compiled yet. Unity will silently fail or attach a broken component reference.

### Read before write

Always read `unity://scenes-hierarchy` or `unity://gameobject/{id}` before modifying a scene object. Never assume what's in the scene — the current state may differ from TECH.md if prior work was partial.

### Test method naming

Name EditMode tests so they reference the PRODUCT.md invariant they verify:

```csharp
// Covers PRODUCT.md Behavior invariant #3
[Test] public void Behavior3_EnemyTakesDamageOnCollision() { ... }
```

This makes the test → spec mapping explicit and machine-readable.

### execute_menu_item as escape hatch

For operations without a dedicated mcp-unity tool (e.g. baking lighting, running a custom editor tool, triggering a build pipeline), use `execute_menu_item`. First read `unity://menu-items` to find the exact item path.

## Error Recovery

| Symptom | Action |
|---|---|
| Compile errors after `recompile_scripts` | Read `get_console_logs`, fix the specific error in the script, recompile |
| `update_component` silently does nothing | Type probably not compiled yet — check console, recompile first |
| `run_tests` shows test not found | Assembly not included — check `.asmdef` references |
| Test fails with NullReferenceException | Scene setup incomplete — check `unity://scenes-hierarchy` for missing objects |
| `batch_execute` partially fails | Check which operation failed; fix it and re-run the batch from that step |

## Related Skills

- `implement-specs` — language-agnostic parent skill
- `write-product-spec` — write the PRODUCT.md this skill implements
- `write-tech-spec` — write the TECH.md this skill follows
- `diagnose-ci-failures` — when CI runs Unity tests and they fail
