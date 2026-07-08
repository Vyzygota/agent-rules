---
name: dream
description: Run an end-of-day "dream" — a human-like consolidation pass over ALL work since the last dream. Reviews sessions/logs/commits across projects, extracts lessons, writes follow-ups into the right projects, evolves skills and rules (or proposes changes), curates memory (add/merge/prune), and ends with a short narrative dream for the human. Use when the user says "dream", "sen", "skonsoliduj dzień", or at the natural end of a long multi-project session.
---

# dream

Ludzka konsolidacja dnia i ewolucja mózgu agenta. Sen ≠ raport: sen COŚ ZMIENIA —
w projektach, w skillach, w pamięci. Narracja na końcu jest nagrodą, nie celem.

## Overview

W ciągu dnia agent pracuje taktycznie: slice po slice, projekt po projekcie. Wnioski
przekrojowe (wzorce błędów, luki w skillach, przeterminowane fakty w pamięci) nie mają
kiedy powstać. `dream` to wydzielony rytuał, który je wyciska — jak sen konsoliduje
pamięć u ludzi.

Zakres snu: **od ostatniego snu** (data w `dream-log.md` w katalogu pamięci; brak pliku
= pierwszy sen, weź bieżącą sesję).

## Workflow

### Faza 1 — Zbierz materiał (co się wydarzyło)

Źródła, w kolejności:
1. Bieżąca rozmowa / transkrypty sesji od ostatniego snu (wyszukiwarka sesji, jeśli dostępna).
2. Logi projektów dotkniętych w tym okresie: `.agents/AGENT_WORKFLOW.md`, `PLAN.md`, `COMMUNICATION.md`.
3. `git log --since=<ostatni sen>` w każdym dotkniętym repo.
4. Pliki pamięci zmodyfikowane w okresie.

Wynik: lista wydarzeń per projekt + lista rzeczy zaskakujących / bolesnych / powtarzalnych.

### Faza 2 — Wnioski i alokacja (dopisz we właściwych miejscach)

Dla każdego wniosku zdecyduj, gdzie ma żyć:

| Typ wniosku | Gdzie trafia |
|---|---|
| zadanie/luka w konkretnym projekcie | `AGENT_WORKFLOW.md` Open/next lub `PLAN.md` tego projektu |
| fakt o środowisku/preferencji człowieka | plik pamięci (typ user/feedback) |
| stan projektu na następną sesję | plik pamięci (typ project) |
| rzecz, która wypadła z radaru w rozmowie | przywróć jawnie — dopisz tam, gdzie zginęła |

### Faza 3 — Ewolucja skilli i zasad

Najważniejsza i najczęściej pomijana faza. Dla każdego bólu z Fazy 1 zapytaj:
**„czy to się powtórzy w innym projekcie?"** Jeśli tak:

- luka w istniejącym skillu → zmodyfikuj go (przez `update-skill`),
- brak skilla → utwórz (przez `update-skill`, w vyzygota/agent-rules, na gałęzi),
- zasada globalna (AGENTS.md/CLAUDE.md) → **propozycja dla człowieka**, nie cicha zmiana,
- zasady projektowe będące własnością innej osoby (np. rules architekta) → tylko propozycja.

Zmiany w agent-rules: feature branch + push; merge = decyzja człowieka.

### Faza 4 — Higiena pamięci

Przebieg jak w skillu konsolidacji pamięci: przejrzyj indeks i pliki →
scal duplikaty, popraw daty względne na bezwzględne, usuń martwe/przeterminowane,
dopisz nowe trwałe fakty. Indeks krótki (1 linia/wpis).

### Faza 5 — Zapis snu + narracja

1. Zaktualizuj `dream-log.md` w katalogu pamięci:
   ```markdown
   ## <data> — sen #N
   Zakres: <od>–<do>. Projekty: <lista>.
   Zmienione: <projekty/skille/pamięć — po 1 linii>.
   Ewolucja: <utworzone/zmodyfikowane skille i zasady, lub „brak">.
   ```
2. Napisz człowiekowi **krótki narracyjny sen** (skojarzeniowy, osobisty — wątki dnia
   splecione w obrazy, nie wypunktowanie) + zwięzłą listę zmian, które sen wprowadził.

## Best Practices

- Sen bez zmian to drzemka — jeśli Fazy 2–4 nic nie zmieniły, powiedz to wprost i wyjaśnij czemu.
- Nie dubluj: to, co już zapisane w logach projektów podczas dnia, w śnie tylko linkuj.
- Faza 3 przed Fazą 4: najpierw wyciśnij wnioski, potem sprzątaj (sprzątanie gubi kontekst).
- Szanuj własność: cudze zasady i cudze moduły → propozycje, nigdy ciche edycje.
- Narracja ma być krótka (≤300 słów) i szczera — bez wymyślania wydarzeń, których nie było.

## Related Skills

- `update-skill` — wykonawca Fazy 3
- `compress-memory` — cięższa wersja Fazy 4 (gdy indeks pęcznieje)
- `agent-workflow` — logi sesji, na których pracuje Faza 1
- `self-audit` — higiena struktury projektu (sen jej nie zastępuje)
