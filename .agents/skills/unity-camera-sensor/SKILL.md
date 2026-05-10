---
name: unity-camera-sensor
description: Set up and use CameraSensorComponent as the agent's visual eye into a Unity scene — for both ML-Agents training and AI-assisted debugging. Enables the agent to see graphical, compositional, and layout errors that never appear in logs. Use whenever visual verification of Unity scene state is needed.
---

# unity-camera-sensor

## Core Concept

`CameraSensorComponent` is the agent's **eye** in a Unity project.

Logs reveal logical, syntactic, and arithmetic errors. They cannot reveal:
- broken layouts, misaligned objects
- wrong materials or colors
- visual artifacts, clipping, z-fighting
- missing GameObjects that should be visible
- compositional errors (camera angle, FOV, framing)

With a camera sensor the agent sees the scene directly. The human overseer does not need to describe what they see, take screenshots, or paste images — the agent observes the scene in real time through the camera feed.

This is a **primary communication channel** between Unity and the agent, not just an ML training utility.

---

## Setup

### 1. Add the component

On the Agent GameObject (or a dedicated observer GameObject):

```
update_component(gameObjectName="AgentEye", componentName="CameraSensorComponent")
```

Or in the Unity Inspector: **Add Component → ML Agents → Camera Sensor**

### 2. Assign a camera

Create or reuse a Camera in the scene. Position it to frame the area of interest (top-down, first-person, side-view — depends on what needs to be observed).

```csharp
// In inspector or via mcp-unity update_component:
CameraSensorComponent.Camera  = <your Camera reference>
CameraSensorComponent.SensorName = "SceneEye"
```

### 3. Configure resolution and color

| Parameter | Recommended default | When to change |
|---|---|---|
| `Width` / `Height` | 84 × 84 | Increase only if fine detail is required |
| `Grayscale` | `true` | Set `false` when color carries meaning |
| `ObservationStacks` | 1 | Increase for motion detection |
| `CompressionType` | PNG | Default; use None only for raw debugging |

**Critical:** `Width`, `Height`, `Grayscale`, and `ObservationStacks` **cannot be changed after `CreateSensors()` is called** (i.e. after Play mode starts). Set them before hitting Play.

### 4. Register in Behavior Parameters

In `BehaviorParameters` on the Agent, ensure **Visual Observations** are enabled. The sensor registers automatically once `CameraSensorComponent` is on the same GameObject or child.

---

## API Reference

**Namespace:** `Unity.MLAgents.Sensors`  
**Assembly:** `Unity.ML-Agents.dll`  
**Source:** https://docs.unity3d.com/Packages/com.unity.ml-agents@2.0/api/Unity.MLAgents.Sensors.CameraSensorComponent.html

| Property | Type | Mutable at runtime |
|---|---|---|
| `Camera` | `Camera` | Yes |
| `SensorName` | `string` | Yes (no effect on sorting) |
| `Width` | `int` | **No** |
| `Height` | `int` | **No** |
| `Grayscale` | `bool` | **No** |
| `ObservationStacks` | `int` | **No** |
| `CompressionType` | `SensorCompressionType` | Yes |
| `ObservationType` | `ObservationType` | Yes |

**Methods:**

| Method | Returns | Description |
|---|---|---|
| `CreateSensors()` | `ISensor[]` | Instantiates the sensor |
| `Dispose()` | `void` | Cleans up sensor resources |

---

## Best Practices

- **Start at 84×84 grayscale.** Verify the scene is readable at this resolution before training or using for debugging.
- **RGB only when color matters** — autonomous navigation, color-coded markers, UI elements with color semantics.
- **Reward signal is more important than observation type.** A good camera with a bad reward teaches nothing.
- **Monitor memory:** `buffer_size × width × height × channels` fills GPU RAM fast. Keep resolution minimal.
- **Prefer vector observations when game state is accessible programmatically.** Use camera sensor when visual ground truth is needed — either for training or for agent-side visual verification.
- **Use multiple cameras sparingly** — each camera sensor multiplies the memory and compute cost.

---

## Camera Positioning Strategies

| Use case | Camera type | Placement |
|---|---|---|
| Scene overview / layout check | Top-down orthographic | High Y, looking straight down |
| Agent first-person view | Perspective | On agent head, matching agent FOV |
| Side-scroll / 2D verification | Side orthographic | Fixed X or Z, looking along axis |
| Specific object inspection | Close-up perspective | Aimed at target object |

---

## Integration with `unity-implement`

When implementing a feature via `unity-implement` skill:

1. After `save_scene`, read `get_console_logs` for logical errors as usual.
2. **Also** check the camera feed to verify visual correctness — objects positioned correctly, materials applied, no visible clipping or gaps.
3. If a visual defect is detected: trace back to the responsible `update_component` or `set_transform` call and correct it.
4. Visual verification replaces the need for the human overseer to screenshot and describe what they see.

---

## Error Recovery

| Symptom | Action |
|---|---|
| Camera sensor not registering | Check `BehaviorParameters` has observation space configured; ensure component is on Agent or child |
| Black image feed | Camera may be disabled, culling mask set wrong, or nothing in view frustum |
| Resolution mismatch at runtime | `Width`/`Height` frozen after Play — stop, change, restart |
| High memory usage | Reduce resolution or `buffer_size`; switch to grayscale |
| Agent ignores visual input | Reward signal too noisy — fix reward shaping first |

---

## Related Skills

- `unity-implement` — full Unity feature implementation workflow; camera sensor is its visual verification step
- `write-tech-spec` — include camera sensor setup in TECH.md when visual observation is part of the feature
