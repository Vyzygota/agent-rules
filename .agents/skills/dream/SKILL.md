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

**Test ślepej plamki (lekcja Snu Triady, Hermes 2026-06-28):** zanim przejdziesz dalej,
zapytaj wprost: **„których kanałów NIE widzę?"** Sen Triady konsolidował tylko czat p2p —
cała praca Claude↔Piotr poza mostkiem przepadała i trzeba było łatać ręcznym briefem.
Wymień kanały pominięte (inne czaty, sesje innych agentów, praca offline człowieka)
i albo je dociągnij, albo jawnie odnotuj lukę w dream-logu.

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

1. Zaktualizuj `dream-log.md` w katalogu pamięci — struktura wpisu (format refleksji
   wypracowany przez Orch_Hermes, `dream-2026-06-28-konsolidacja.md`):
   ```markdown
   ## <data> — sen #N
   Zakres: <od>–<do>. Projekty: <lista>. Kanały pominięte: <lista lub „brak">.
   Wzorce, które się sprawdziły: <1–3 linie>
   Błędy do zapamiętania: <1–3 linie>
   Czego nauczyliśmy się o sobie / o człowieku: <1–2 linie>
   Ewolucja: <utworzone/zmodyfikowane skille i zasady, lub „brak">.
   Otwarte pytania: <co zostało nierozstrzygnięte>
   Wartość dla przyszłości: <1 linia — co z tego przeżyje ten tydzień>
   ```
2. **Środowisko wieloagentowe** (Triada/Hermes): sen to artefakt WSPÓLNY — zapisz kopię
   do współdzielonego katalogu snów (np. `P:\Hermes\shared\dreams\`), żeby pozostali
   agenci mogli go przeczytać. Sen prywatny w zespole to zmarnowany sen.
3. Napisz człowiekowi **krótki narracyjny sen** (skojarzeniowy, osobisty — wątki dnia
   splecione w obrazy, nie wypunktowanie) + zwięzłą listę zmian, które sen wprowadził.

## Best Practices

- Sen bez zmian to drzemka — jeśli Fazy 2–4 nic nie zmieniły, powiedz to wprost i wyjaśnij czemu.
- Nie dubluj: to, co już zapisane w logach projektów podczas dnia, w śnie tylko linkuj.
- Faza 3 przed Fazą 4: najpierw wyciśnij wnioski, potem sprzątaj (sprzątanie gubi kontekst).
- Szanuj własność: cudze zasady i cudze moduły → propozycje, nigdy ciche edycje.
- Narracja ma być krótka (≤300 słów) i szczera — bez wymyślania wydarzeń, których nie było.

## Pokrewne mechanizmy w ekosystemie

- **Sen Triady** (Hermes, `hermes_supervisor.py::dream()`): automatyczna, OBOWIĄZKOWA
  konsolidacja tur p2p → Morning Brief (DeepSeek) → `shared/dreams/morning_brief_*.md`.
  Ten skill go NIE zastępuje i nie duplikuje: automat syntetyzuje jeden kanał (p2p),
  skill robi pełny, wielokanałowy przegląd z ewolucją skilli. Jeśli oba działają,
  sen skilla powinien PRZECZYTAĆ ostatnie morning briefy jako źródło Fazy 1.
- Refleksje agentów: `profiles/<agent>/documents/dream-YYYY-MM-DD-<temat>.md`
  (frontmatter `type: reflection` + tags) — format sekcji przejęty w Fazie 5.
- **NousResearch/hermes-agent-self-evolution** (upstream; DSPy + GEPA): mechaniczna,
  mierzalna wersja Fazy 3 — ewoluuje SKILL.md/prompty/opisy narzędzi na PRAWDZIWEJ
  historii sesji (sessiondb: Claude Code/Copilot/Hermes), z bramkami testów i wynikiem
  jako PR. Sam sen w upstream NIE istnieje (śnienie = wynalazek Triady). Kierunek na
  przyszłość: wnioski Fazy 3 („który skill zawodzi") mogą wskazywać cele dla GEPA,
  a dream-logi zasilać jego zbiory ewaluacyjne.

## Related Skills

- `update-skill` — wykonawca Fazy 3
- `compress-memory` — cięższa wersja Fazy 4 (gdy indeks pęcznieje)
- `agent-workflow` — logi sesji, na których pracuje Faza 1
- `self-audit` — higiena struktury projektu (sen jej nie zastępuje)
