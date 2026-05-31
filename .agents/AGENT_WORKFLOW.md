# Agent Workflow — agent-rules

> Session log. Newest entries at top. Tags: #keyword for memory index.

---

## 2026-05-31 14:00 — Claude Code — self-audit zewnętrznych narzędzi
Tags: #warp-watch #self-audit #graphify #playwriter #check-impl-against-spec

**Done:**
- Pełny przegląd 19 skillów z skills-lock.json pod kątem zewnętrznych zależności
- graphify v0.8.26 (2026-05-30): dodano import cycles, custom provider registry, GRAPHIFY_DEBUG, anchored .graphifyignore fix
- check-impl-against-spec: upstream diverged (spec_context.md + review.json = Oz pipeline); nasza wersja lepsza dla naszego workflow — zostaje
- council, resolve-merge-conflicts: SHA zgodny z upstream ✓

**Open / next:**
- Brak

---

## 2026-05-31 13:00 — Claude Code — warp-watch sync
Tags: #warp-watch #skills-lock #agent-workflow #sync

**Done:**
- Sprawdzono warpdotdev/warp commits (2026-05-24 → 2026-05-31): seria [1/5]–[5/5] Remote project skills (platforma Rust, brak zmian w naszym formacie)
- Sprawdzono common-skills: 1 nowy skill respond-to-pr-comments-in-blocklist — pominięty (Warp/Oz branding)
- Naprawiono agent-workflow skill: dodano YAML frontmatter, dodano do skills-lock.json
- Zaktualizowano daty sync: CLAUDE.md, AGENTS.md → 2026-05-31
- Zaktualizowano warp-watch.md z nowym wpisem
- Zaktualizowano .agents/rules/WORKSPACE.md (agent-workflow layer docs + /agent-workflow invocation)
- Dodano .claude/settings.json hook: pre-push guard dla COMMUNICATION.md/AGENT_WORKFLOW.md

**Open / next:**
- Brak — sync kompletny
