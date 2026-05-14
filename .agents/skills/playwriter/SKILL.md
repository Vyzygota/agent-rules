---
name: playwriter
description: Use Playwriter to directly control the user's actual Chrome browser for E2E testing, scraping, or web tasks. Leverages the user's active session (cookies, logins, extensions). Uses accessibility snapshots instead of heavy screenshots.
---

# playwriter

## Core Concept

Playwriter is an MCP server and CLI that allows agents to control the user's *actual* Chrome browser. 
Unlike standard Playwright which spins up a new headless instance (losing cookies and triggering bot detection), Playwriter attaches to the user's existing Chrome tabs.

Key properties:
- **Zero Bot Detection** — Uses the user's real browser profile.
- **Shared Session** — All logins, cookies, and extensions are already present.
- **Accessibility Snapshots** — Instead of taking expensive 100KB+ screenshots, the agent receives a lightweight text tree of interactive elements with specific locators.
- **Collaboration** — The user can watch the agent work and step in if a CAPTCHA or 2FA prompt appears.

---

## Installation

### 1. Install CLI
```bash
npm i -g playwriter
```

### 2. Install Chrome Extension
Install the [Playwriter MCP Chrome Extension](https://chromewebstore.google.com/detail/playwriter-mcp/jfeammnjpkecdekppnclgkkffahnhfhe).
Click the extension icon on a tab to connect it (it will turn green).

### 3. Add to Antigravity (`mcp_config.json`)
```json
    "playwriter": {
      "command": "npx.cmd",
      "args": [
        "-y",
        "playwriter"
      ]
    }
```

---

## Workflow & Best Practices

1. **Accessibility Snapshots over Screenshots:**
   When navigating to a page, always request an accessibility snapshot first. It returns a lightweight tree of interactive elements with pre-calculated `page.locator(...)` queries.
   ```bash
   playwriter -e "snapshot({ page, search: /button|submit/i })"
   ```

2. **Isolated State:**
   Use the `state` object to share variables between executions without polluting the browser window.
   ```bash
   playwriter -s 1 -e "state.myPage = context.pages().find(p => p.url() === 'about:blank') ?? context.newPage();"
   ```

3. **Visual Labels (Fallback):**
   If the accessibility snapshot isn't enough to understand spatial layout, use Vimium-style visual labels.
   ```bash
   playwriter -e "screenshotWithAccessibilityLabels({ page })"
   ```

4. **Network Interception:**
   Instead of scraping the DOM, intercept API responses directly.
   ```bash
   playwriter -e "state.responses = []; page.on('response', async res => { if (res.url().includes('/api/')) state.responses.push(await res.json()) })"
   ```

---

## Source

- GitHub: https://github.com/remorses/playwriter
- Website: https://playwriter.dev/
