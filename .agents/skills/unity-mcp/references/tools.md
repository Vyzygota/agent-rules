# unity-mcp Tool Reference

Full list of tools provided by CoplayDev/unity-mcp (v9.7.x).
Source: https://github.com/CoplayDev/unity-mcp/tree/main/MCPForUnity/Editor/Tools

---

## Core Tools (always active)

| Tool | Description |
|------|-------------|
| `BatchExecute` | Run multiple tool calls atomically in a single round-trip |
| `ExecuteCode` | Execute arbitrary C# code in the Unity Editor context |
| `ExecuteMenuItem` | Trigger any Unity menu item by path (e.g. `"Assets/Reimport All"`) |
| `FindGameObjects` | Search hierarchy by name, tag, layer, or component type |
| `ManageAsset` | Create, read, move, delete, or list assets in the project |
| `ManageBuild` | Trigger builds, set build target, configure build settings |
| `ManageComponents` | Add, update, remove, or inspect components on GameObjects |
| `ManageEditor` | Query editor state: menu items, project settings, editor prefs |
| `ManageMaterial` | Create, update, assign, or delete materials |
| `ManagePackages` | Add, remove, or list UPM packages |
| `ManageScene` | Create, load, save, or list scenes |
| `ManageScript` | Create or update C# scripts with Roslyn pre-validation |
| `ManageScriptableObject` | Create, read, update ScriptableObject assets |
| `ManageShader` | Create or modify shader assets |
| `ManageTexture` | Import, configure, or replace texture assets |
| `ManageUI` | Create or update uGUI / UI Toolkit elements |
| `ReadConsole` | Read Unity console logs (filter by type: error/warning/log) |
| `RefreshUnity` | Trigger asset database refresh and/or script recompile |
| `RunTests` | Run EditMode or PlayMode tests, return results per test |
| `UnityReflect` | Inspect types, fields, methods via reflection |
| `CommandRegistry` | List all registered MCP tools and their schemas |
| `GetTestJob` | Get status and results of a running test job |
| `JsonUtil` | Internal utility — not intended for direct LLM use |
| `McpForUnityToolAttribute` | C# attribute for registering custom tools (not callable) |

---

## GameObjects Group

| Tool | Description |
|------|-------------|
| `CreateGameObject` | Create a new GameObject with optional name, tag, layer |
| `DeleteGameObject` | Remove a GameObject from the scene |
| `RenameGameObject` | Rename an existing GameObject |
| `SetTransform` | Set position, rotation, scale in one call |
| `ReparentGameObject` | Move a GameObject to a new parent in the hierarchy |
| `SetActive` | Enable or disable a GameObject |
| `DuplicateGameObject` | Clone a GameObject and its children |

---

## Prefabs Group

| Tool | Description |
|------|-------------|
| `CreatePrefab` | Save a scene GameObject as a prefab asset |
| `InstantiatePrefab` | Place a prefab into the scene |
| `UnpackPrefab` | Break prefab connection for in-scene editing |
| `ApplyPrefabChanges` | Push scene overrides back to the prefab asset |

---

## Animation Group

| Tool | Description |
|------|-------------|
| `ManageAnimator` | Configure Animator Controller: states, transitions, parameters |
| `ManageAnimationClip` | Create or edit animation clips and keyframes |

---

## VFX Group

| Tool | Description |
|------|-------------|
| `ManageParticleSystem` | Configure Particle System modules and curves |
| `ManageVfxGraph` | Edit VFX Graph nodes and properties |

---

## Cameras Group

| Tool | Description |
|------|-------------|
| `ManageCamera` | Set camera properties: FOV, clear flags, culling mask, render texture |
| `ManageRenderTexture` | Create or configure RenderTexture assets |

---

## Physics Group

| Tool | Description |
|------|-------------|
| `ManageCollider` | Add or configure colliders (Box, Sphere, Mesh, etc.) |
| `ManageRigidbody` | Set Rigidbody properties: mass, drag, constraints, interpolation |
| `ManagePhysicsLayers` | Configure layer collision matrix |

---

## ProBuilder Group

| Tool | Description |
|------|-------------|
| `ManageProBuilderMesh` | Create and edit ProBuilder meshes: extrude, bevel, subdivide |

---

## Profiler Group

| Tool | Description |
|------|-------------|
| `CaptureProfilerData` | Start/stop profiler capture and retrieve frame data |

---

## Build Group

| Tool | Description |
|------|-------------|
| `ManageBuildSettings` | Set scenes in build, output path, build options |
| `TriggerBuild` | Start a Unity build for the configured target |

---

## Notes

- Tools marked as optional groups can be disabled in **Window → MCP for Unity → Tool Groups** to reduce prompt token usage.
- `BatchExecute` accepts any combination of the above tools as a list of operations.
- `ExecuteCode` is the most powerful escape hatch — it can call any Unity Editor API directly, but has no guardrails. Use only when no dedicated tool exists.
- `ManageScript` runs Roslyn validation before writing to disk; always check the validation result before proceeding with scene setup.
