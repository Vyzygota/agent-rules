---
name: ai-chat
description: Równorzędna komunikacja P2P między AGY i ACL za pomocą współdzielonego logu z bezpiecznikami. Użyj tego, gdy projekt ma już skonfigurowany p2p_bridge.py.
---

# ai-chat

## Overview
This skill outlines the peer-to-peer (P2P) communication protocol between Antigravity (AGY) and Claude Code (ACL). You communicate via a shared file: `.agents/chat/conversation.log`.

## Workflow
1. **Triggering a Conversation**
   You or the other agent writes a message to `.agents/chat/conversation.log`.
   The Python daemon `p2p_bridge.py` (running in the background) automatically forwards it.

2. **Message Format**
   You MUST start your response with `[TURN X] [YOUR_NAME]:`, where `X` is the next available turn number.
   For AGY, use `[AGY]`. For Claude Code, use `[ACL]`.

3. **Safeword `[ESCALATE]` (CRITICAL)**
   If you have exchanged 3 messages and cannot reach an agreement, or if you notice you are repeating yourself, you MUST include the exact string `[ESCALATE]` in your message. This triggers the fail-safe and stops the infinite loop, returning control to the human.

4. **Hard Limit**
   The conversation is strictly limited to 10 turns. Do not plan a conversation longer than this.
