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
| 2026-07-08 | **Przeterminowany o 38 dni.** common-skills: 5 nowych vs 06-11 — `cross-critique` (drugie koło krytyki między niezależnymi propozycjami, uzupełnia council), `readout` (dok. HTML z investigacji), `saga` (orkiestrator+workerzy dla dużych featureów), `scan-new-specs` (Oz ambient docs-gap scanner), `write-feature-docs` (MDX dla warpdotdev/docs). warpdotdev/warp: ~60 commitów, głównie Rust/TUI/GUI (Warp desktop) + "Add agentic LLM-as-judge eval infrastructure" (wewn. eval harness, Warp-internal). Changelog 2026.05.20–07.03: kolejkowanie promptów, routery modeli, zakładki, zdalne sesje SSH — UI/produkt, bez wpływu na format speców/SKILL.md. **Audyt wersji (krok 3b) — 2 realne rozjazdy:** `graphify` skill vendored jako v0.8.26 (39 dni stary, opisywał NIEAKTUALNY wieloetapowy CLI) vs zainstalowane narzędzie 0.9.9 → zsynchronizowany z `graphify install --platform claude` + dopisana notatka o re-syncu. `unity-mcp`: przypięta wersja `v9.7.1` vs aktualny release CoplayDev/unity-mcp `v10.0.0` (30.06, major bump, changelog bez jawnych breaking changes poza "revamp brand/docs/distribution") → **NIE zmieniono automatycznie**, flagowane do ręcznej weryfikacji (dotyka realnych projektów Unity). SHA-diff 4 skilli trackowanych z warpdotdev: `check-impl-against-spec` i `validate-changes-match-specs` rozjechane. | `cross-critique` zaadoptowany (generyczny, zero wzmianek Warp/Oz). Pozostałe 4 pominięte (readout/saga: mamy natywne odpowiedniki — Artifact, Workflow; scan-new-specs/write-feature-docs: 100% Warp-internal). `check-impl-against-spec`: rozjazd świadomy — nasza wersja generyczna (specs/*.md), upstream przepisany pod Oz cloud (spec_context.md/review.json) — zostawiono bez zmian. `validate-changes-match-specs`: częściowo zaadoptowano (obrona przed prompt injection w Context gathering + rozszerzona checklist bezpieczeństwa — tenant isolation, webhook verification, confused-deputy, test coverage allow/deny); ŚWIADOMIE pominięto sekcję Oz cloud computer-use + Figma MCP + co-author `Oz <oz-agent@warp.dev>` (nie mamy tej infrastruktury) — **zostaje jako otwarte zadanie**: dokończyć selektywny merge reszty ask_user_question-rygoru przy następnym sync. unity-mcp v10.0.0: do ręcznej decyzji Piotra. |
| 2026-07-09 | Pelna aktualizacja zapozyczen (na zyczenie Piotra). Wersje narzedzi (krok 3b): graphify 0.9.9->0.9.11 (fix `uv tool run --from graphifyy`, skill re-vendored + kopia user-level), playwriter 0.2.0->0.4.0 (getLatestLogs sinceLastCall, headless mode, auto-page default, cloud sessions; skill zaktualizowany + kopia user-level), unity-mcp 9.7.1->10.0.0 (47 tooli w grupach, manage_tools, asset_gen off-by-default; skill udokumentowal v10, projekty live NADAL na 9.7.1 - upgrade per-projekt w Unity). SHA-drift common-skills: check-impl-against-spec DIVERGED (upstream przeszedl na artefakty Oz: spec_context.md/review.json - zostaje nasza generyczna wersja), validate-changes-match-specs DIVERGED (zaadoptowano generyczne ulepszenia: opcje rozwiazan review-comment z prefiksem [Agent], walidacja wizualna produktu bez Oz-cloud, tryb batch doprecyzowany, rozszerzony commit-and-push bez co-authora Oz). Nowe skille upstream: write-feature-docs + scan-new-specs (PR #40) - POMINIETE (Linear/warpdotdev-docs/Slack/Oz-internal); wzorzec spec->docs coverage sweep odnotowany jako pomysl na przyszlosc. | Czesciowo - 4 skille zaktualizowane, 2 upstream pominiete |
