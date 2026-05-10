# Warp-Watch Protocol

Procedura sprawdzania co nowego w ekosystemie Warp i aktualizacji globalnych zasad.

## Kiedy uruchamiać

- Na początku nowego projektu
- Raz w miesiącu podczas aktywnego developmentu
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
