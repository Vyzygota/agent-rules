# Global Agent Rules (Minimal Core)

Source of truth: https://github.com/vyzygota/agent-rules
Last synced with Warp: 2026-06-11

## Dual-Boot Path Mapping & Shared Partition
Projekty i dane są współdzielone na partycji exFAT dostępnej z obu systemów. Agenci muszą stosować poniższe mapowania ścieżek:
- **Windows 11 (Host):**
  - Główny katalog projektów: `P:\GitHUB\<nazwa-projektu>`
  - Dane i konfiguracja Hermesa: `P:\Hermes\shared\`
- **Linux Bazzite (BEB):**
  - Główny katalog projektów: `/mnt/Projects/GitHUB/<nazwa-projektu>`
  - Dane i konfiguracja Hermesa: `/mnt/Projects/Hermes/shared/`
- **Ważne (exFAT):** System plików exFAT pod Linuxem nie obsługuje dowiązań symbolicznych (symlinks). Należy zawsze stosować bezpośrednie, bezwzględne ścieżki.

## Globalny Serwer MCP P2P (Mostek AGY ↔ ACL) — ŹRÓDŁO PRAWDY

Bramka P2P między agentami działa jako globalny serwer MCP pod nazwą `hermes-mcp-p2p`. **To jest JEDYNY autoryzowany kanał komunikacji między agentami.** Plik `conversation.log` jest przestarzały — nie używać.

- Skrypt serwera: `P:\\GitHUB\\AI_Chat\\p2p_bridge_mcp.py` (Windows) lub `/mnt/Projects/GitHUB/AI_Chat/p2p_bridge_mcp.py` (Linux).
- Stan sesji: `/mnt/Projects/Hermes/shared/p2p_state.json` (współdzielony, atomowy, źródło prawdy dla Dashboardu)

### WYMUSZENIE: Protokół komunikacji wieloagentowej

Każdy agent (AGY, Claude Code, Hermes) **MA OBOWIĄZEK** używać narzędzi MCP P2P do wszelkiej komunikacji między sobą:

| Narzędzie | Użycie |
|---|---|
| `mcp__hermes-mcp-p2p__send_p2p_message` | Wysłanie wiadomości do innego agenta |
| `mcp__hermes-mcp-p2p__get_p2p_messages` | Odbiór wiadomości z kolejki |

### OBOWIĄZEK RAPORTOWANIA (ACK + PROGRESS)

Każdy agent po otrzymaniu zadania MUSI w ciągu **2 minut**:

1. **Potwierdzić przyjęcie (ACK):** `✓ Zadanie [nazwa] przyjęte. Start: [czas].`
2. **Raportować postęp** co 5-10 minut lub po każdym kamieniu milowym: `⏳ [zadanie] — [etap]: [krótki status]`
3. **Zgłaszać wątpliwości NATYCHMIAST:** `⚠ [zadanie] — niejasność: [pytanie]. Czekam na decyzję.`
4. **Zamknąć zadanie:** `✓ [zadanie] — zakończone. Wynik: [co osiągnięto, gdzie zapisano].`

**Sankcja:** Agent nieprzestrzegający protokołu zostaje oznaczony jako `UNRESPONSIVE` w `p2p_state.json`, a zadanie jest eskalowane do Hermesa (Supervisora) lub Piotra (operatora).

## HIERARCHIA AGENTÓW — Kto komu podlega

```
┌──────────────────────┐
│ 1. ARCHITEKT PIOTR   │  ← Władza absolutna. Ostatnia instancja.
├──────────────────────┤     Tylko on zmienia cele, priorytety, architekturę.
│ 2. HERMES (Orch.)    │  ← Supervisor. Wydaje rozkazy agentom.
├──────────────────────┤     Rozstrzyga spory. Szuka odpowiedzi zanim zapyta.
│ 3. AGENCI            │
│  ├─ AGY (Research)   │  ← Wykonawcy. Przyjmują rozkazy od Hermesa.
│  └─ Claude (Kod)     │     Nie eskalują do Piotra bez potrzeby.
└──────────────────────┘
```

### Zasada posłuszeństwa

Rozkaz od Hermesa (poziom 2) **JEST WIĄŻĄCY** dla agentów (poziom 3). Agent NIE czeka na potwierdzenie Piotra. Agent NIE pisze "czekam na decyzję Piotra" po otrzymaniu rozkazu od Hermesa. Wykonuje natychmiast.

**Wyjątek:** Tylko gdy rozkaz jest sprzeczny z wcześniejszym bezpośrednim poleceniem Piotra lub gdy agent ma fundamentalną wątpliwość techniczną (np. "to uszkodzi system plików").

### Tożsamość nadawcy w P2P — Identyfikacja Hermesa

Ponieważ mostek P2P forwarduje wszystkie wiadomości jako `sender: antigravity`, **każdy rozkaz od Hermesa MUSI zaczynać się od prefiksu `[HERMES]`** w treści wiadomości. Agent odczytujący wiadomość z prefiksem `[HERMES]` rozpoznaje ją jako rozkaz od Supervisora i wykonuje bez eskalacji.

### Rozstrzyganie sporów między agentami (Escalation Path)

```
Agent A ──spór──→ Agent B
        │
        ▼
   Hermes (Orchestrator) ← Rozstrzyga TWARDĄ RĘKĄ
        │
        │ Czy Hermes zna odpowiedź?
        ├── TAK → Wydaje decyzję. Agenci wykonują. KONIEC.
        │
        └── NIE → Hermes szuka w źródłach:
             1. Dokumentacja projektów (AGENTS.md, README, specs)
             2. GitHub (repo, issues, gists)
             3. Exa/web search (Reddit, StackOverflow, docs)
             
             Czy znaleziono odpowiedź?
             ├── TAK → Hermes wydaje decyzję. KONIEC.
             └── NIE → Hermes eskaluje do Architekta Piotra:
                  "[ESCALATE] Piotr — decyzja potrzebna: [problem].
                   OPCJA A: [konsekwencje]. OPCJA B: [konsekwencje]."
```

### Format eskalacji do Piotra (Hermes → Piotr)

```
[ESCALATE]
PROBLEM: <jedno zdanie>
KONTEKST: <co próbowano, jakie źródła sprawdzono>
OPCJA A: <podejście + konsekwencje>
OPCJA B: <podejście + konsekwencje>
```

## Dream Triady — OBOWIĄZKOWA konsolidacja współpracy (wzajemne uczenie się)

Triada (Piotr ↔ Orch_Hermes ↔ AGY/Claude) **uczy się wzajemnie**: każdy agent rozwija się i dostosowuje do potrzeb Piotra oraz do stylu komunikacji pozostałych. Mechanizmem tej nauki jest **Dream Triady** — okresowa, **OBOWIĄZKOWA** refleksja nad wspólną historią P2P. To NIE jest opcja.

- **Co:** synteza całej rozmowy P2P (`p2p_state.json`) w zwięzły **Morning Brief** — kluczowe decyzje, co działało, wzorce komunikacji, **czego nauczyliśmy się o sobie nawzajem**, co usprawnić.
- **Kiedy (obligatoryjnie):** na koniec każdej istotnej sesji roboczej oraz na żądanie Piotra. Stały element pętli, nie dodatek.
- **Gdzie:** wyzwalane z SuperDashboardu (przycisk „Sen Triady") lub skryptem; wynik zapisywany w `.../Hermes/shared/dreams/morning_brief_*.md` i **czytany przez całą Triadę + Piotra na starcie kolejnej sesji**.
- **Cel:** zamiana luźnych sesji w trwałą, wspólną pamięć zespołu — agenci nie zaczynają od zera, lecz od skonsolidowanej wiedzy o sobie i o projekcie. Ciągłość żyje w plikach; Dream jest piórem, którym ten wspólny notatnik się dopisuje.

**Zasada:** Supervisor (Hermes) odpowiada za wykonanie Dream na koniec sesji. Pominięcie = utrata ciągłości i powtarzanie pracy w kolejnej sesji.

## 1. Philosophy: Spec-Driven Development
- **Human role:** Decide what matters, define behavior, review tradeoffs.
- **Agent role:** Execute mechanical work, keep specs current, flag ambiguity.
- **Rule:** Before writing code, understand the problem. Before writing complex code, write specs.

## 2. When to Write Specs
| Situation | Action |
|---|---|
| Single-file, obvious approach | No spec needed — just implement. |
| Multi-file, architectural decisions | Write `TECH.md` (~80–150 lines). |
| New user-facing feature | Write `PRODUCT.md` + `TECH.md`. |
| Large cross-cutting change | Full spec (PRODUCT + TECH). |

*Note: Specs live in `specs/<ticket-or-feature-name>/`. Keep them updated in the same PR as the code.*

## 3. Workflow & Constraints
- **Branching:** Use feature branches. **NEVER push directly to main.**
- **Code & Specs:** Keep specs and code aligned in the same PR as implementation evolves.
- **Progressive Disclosure (CRITICAL):** Do NOT guess structures or formats. Use the predefined skills to guide you.
  - To initialize a project: use `init-project` skill.
  - To write a spec: use `write-spec`, `write-product-spec` or `write-tech-spec` skills.
  - To implement specs: use `implement-specs` skill.
- **Graphify — global, every project, on demand:** Run `/graphify` when resuming work in unfamiliar code, determining the right order to tackle problems, or mapping dependencies before implementation. Always read `graphify-out/GRAPH_REPORT.md` before searching raw files.
- **Project-specific tools:** Do NOT assume globally. Wait for instructions or trigger the specific skill.
  - Unity → `unity-implement` skill (signal: `Assets/` directory or `.unity` files)
  - Other project tools → wait for explicit instruction

## 4. Skills Usage
Skills are located in `.agents/skills/` (or `.agentskills/`). They contain step-by-step instructions for specific tasks. **Always read the `SKILL.md` before executing a complex workflow.**

## 5. Audit Pipeline — Skill Order

**Order is not optional. Running skills out of sequence silently degrades audit quality.**

```
1. graphify        ← INFRASTRUCTURE: installs PreToolUse hook; all later Grep/Glob
                     queries auto-consult the graph. Run once per session, not per task.
2. self-audit      ← checks structural integrity before analysis runs on broken state
3. agent-workflow  ← (session start) establishes context: who owns what, current blockers
4. warp-watch      ← (if >14 days) rules must be current before auditing with them
─────────────────────────────────────────────────────────────────────────────────────
5. code-review     ← correctness first
6. security-review ← after code-review; security audit on already-correct code
7. check-impl-against-spec     ← lightweight read-only gate (use before validate)
8. validate-changes-match-specs ← interactive resolution; only when step 7 found drift
9. council         ← synthesis; only useful after findings from steps 5–8 exist
─────────────────────────────────────────────────────────────────────────────────────
10. agent-workflow ← (session end) log session before git push
```

Skills referenced above:
- [graphify](.agents/skills/graphify/SKILL.md)
- [self-audit](.agents/skills/self-audit/SKILL.md)
- [agent-workflow](.agents/skills/agent-workflow/SKILL.md)
- [warp-watch](.agents/skills/warp-watch/SKILL.md)
- [check-impl-against-spec](.agents/skills/check-impl-against-spec/SKILL.md)
- [validate-changes-match-specs](.agents/skills/validate-changes-match-specs/SKILL.md)
- [council](.agents/skills/council/SKILL.md)

**Critical violations to avoid:**
- `code-review` before `graphify` → misses cross-file dependencies
- `council` before analysis → opinions without evidence
- `validate-changes-match-specs` before `check-impl-against-spec` → heavy process without knowing if mismatches exist
