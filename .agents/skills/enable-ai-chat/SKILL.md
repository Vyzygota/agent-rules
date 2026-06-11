---
name: enable-ai-chat
description: Włącza funkcjonalność AI_Chat w aktualnym projekcie poprzez instalację skryptu p2p_bridge.py oraz modyfikację .gitignore i skills-lock.json. Używaj tego na polecenie użytkownika.
---

# enable-ai-chat

## Overview
This skill acts as an installer for the `ai-chat` capability. It copies the necessary resources from the WARPEngine `.agentskills` junction into the project root.

> **CRITICAL RULE**: Instalację przeprowadza się tylko RAZ dla danego projektu. Jeśli Ty to zrobisz, absolutnie NIE PROŚ Claude'a o zrobienie tego samego. Claude zostanie obudzony i poinstruowany automatycznie przez samego demona P2P.

## Installation Steps
Wykonaj następujące kroki używając komend terminala lub narzędzi manipulacji plikami:

1. **Copy the daemon script:**
   Skopiuj `.agentskills/ai-chat/scripts/p2p_bridge.py` (lub `.agents/skills/ai-chat/scripts/p2p_bridge.py`) do głównego katalogu Twojego projektu (root).

2. **Update `.gitignore`:**
   Dopisz (jeśli jeszcze nie ma) linię `.agents/chat/` do pliku `.gitignore`, aby uniknąć wrzucania logów z rozmów do repozytorium.

3. **Update `skills-lock.json`:**
   Upewnij się, że w pliku `skills-lock.json` dodany jest klucz dla `ai-chat` i `enable-ai-chat`, tak by agent mógł korzystać z `ai-chat`.

4. **Notify User:**
   Poinformuj użytkownika, że instalacja przebiegła pomyślnie. Poproś go o otworzenie drugiego okna terminala i wpisanie `python p2p_bridge.py`, a następnie zgłoś gotowość do testowej rozmowy.
