# Warp-Watch Protocol

Procedura sprawdzania co nowego w ekosystemie Warp i aktualizacji globalnych zasad.

## Kiedy uruchamiać

- Na początku nowego projektu
- Raz na 2 tygodnie podczas aktywnego developmentu
- Gdy użytkownik powie: "sprawdź Warp", "zaktualizuj zasady", "co nowego w Warp"

## Repozytoria do śledzenia

| Repo | Co obserwować |
|---|---|
| `warpdotdev/warp` | Commity do WARP.md, nowe katalogi w specs/, releases |
| `warpdotdev/common-skills` | Nowe lub zmienione pliki SKILL.md w .agents/skills/ |
| `docs.warp.dev/changelog/2026/` | Nowe funkcje platformy, zmiany w skills/specs/agents API |

## Kroki procedury

### 1. Sprawdź nowe commity w warpdotdev/warp

Pobierz: https://api.github.com/repos/warpdotdev/warp/commits?per_page=20

Szukaj zmian w: WARP.md, .agents/, specs/, skills-lock.json

### 2. Sprawdź nowe skills w common-skills

Pobierz: https://api.github.com/repos/warpdotdev/common-skills/contents/.agents/skills

Oceniaj czy nowe SKILL.md wprowadzają wzorce warte przyjęcia.

### 3. Sprawdź changelog

Pobierz: https://docs.warp.dev/changelog/2026/

### 4. Oceń co jest relevantne

Adoptuj jeśli zmienia: format PRODUCT.md/TECH.md, format SKILL.md, konwencje AGENTS.md, PR workflow.
Pomiń jeśli dotyczy: Rust/Warp-specificznej implementacji, UI desktop, enterprise features.

### 5. Zaktualizuj i commituj

Zaktualizuj CLAUDE.md i AGENTS.md. Zmień datę "Last synced with Warp". Commituj i pushuj do vyzygota/agent-rules.

## Ostatnie sprawdzenia

| Data | Co znaleziono | Adoptowane? |
|---|---|---|
| 2026-05-10 | Oz Platform, Skills system, PRODUCT.md+TECH.md format | Tak |
| 2026-05-10 | v0.2026.05.06 — Mermaid w output agentów, SSH improvements | Tak |
| 2026-05-10 | common-skills: 11 skillów vs nasze 3. Nowe: write-product-spec, write-tech-spec, spec-driven-implementation, implement-specs, diagnose-ci-failures, update-skill. Brak nowych commitów w warpdotdev/warp po 2026-05-10. | Tak — 6 skillów zaadoptowanych, 2 brakujące SKILL.md uzupełnione |
| 2026-05-24 | common-skills: 9 nowych skillów vs poprzedni sync. Zaadoptowano: council, check-impl-against-spec, resolve-merge-conflicts. Pominięto: brandalf (Warp branding), create-pr (Warp-internal), fix-errors (Rust/WASM), pr-walkthrough (Warp infra), reproduce-bug-report (Oz cloud), review-pr (review.json format). Commity warpdotdev/warp — tylko UI/Rust zmiany, brak zmian w agent patterns. | Tak — 3 skille zaadoptowane |
| 2026-05-31 | common-skills: 1 nowy skill (respond-to-pr-comments-in-blocklist) — pominięty (Warp/Oz branding, Claude Code obsługuje PR comments natywnie). warpdotdev/warp: seria [1/5]–[5/5] Remote project skills — wewnętrzna infrastruktura Rust, potwierdza nasz format skills-lock.json (sourceType: github). Changelog 2026.05.27: Oz CLI commands dla reusable agents, git ops w code review pane — platformowe, bez wpływu na format skills. Dodano wewnętrzny skill agent-workflow (brakował frontmatter i wpisu w skills-lock.json). | Nie adoptowano z zewnątrz. Naprawiono agent-workflow skill. |
| 2026-06-08 | common-skills: 1 nowy skill — `validate-changes-match-specs` (interaktywny workflow walidacji spec vs implementacja, security spec, batch/one-by-one resolution mode). warpdotdev/warp: commity głównie UI (tab groups, horizontal tabs) i Rust. Jedyne agent-related: "filter local skills from remote" (Warp-app internal) i "Warp Control CLI v2 contract spec sync" (Rust internal) — bez wpływu na nasz format. | Tak — zaadoptowano validate-changes-match-specs (stripped z Oz cloud computer-use). |
| 2026-06-11 | common-skills: brak nowych skilli. warpdotdev/warp: nowa specyfikacja "side-by-side diff layout in code review and AI block diffs" (zmiana produktu/UI, bez wpływu na wzorce agentów). Brak zmian do zaadoptowania. | Nie |
| 2026-06-17 | common-skills: brak nowych skilli. check-impl-against-spec i validate-changes-match-specs mają różne SHA vs upstream. check-impl-against-spec upstream przepisany pod Warp review.json pipeline — pominięty. validate-changes-match-specs: zaadoptowano guard prompt-injection w context gathering, rozbudowaną listę security (tenant isolation, webhook verification, confused-deputy, telemetry), doprecyzowanie sekcji commit. warpdotdev/warp: same UI/Rust/tab changes (tab groups, pin state, auto-handoff). Nic do adoptowania z warp. | Częściowo — validate-changes-match-specs zaktualizowany |
