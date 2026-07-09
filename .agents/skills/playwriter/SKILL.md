---
name: playwriter
description: Use Playwriter to directly control the user's actual Chrome browser for E2E testing, scraping, or web tasks. Leverages the user's active session (cookies, logins, extensions). Uses accessibility snapshots instead of heavy screenshots.
---

# playwriter

> v0.4.0 (2026-06-25)

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

2. **Execute from file (`-f` flag) — preferred for multi-step scripts:**
   Instead of long inline `-e` strings, write JS to a file and use `-f`. The file has the same sandbox (`state`, `page`, `context`) as `-e`. `-e` and `-f` are mutually exclusive.
   ```bash
   playwriter -s 1 -f script.js
   ```

3. **Isolated State:**
   Use the `state` object to share variables between executions without polluting the browser window.
   ```bash
   playwriter -s 1 -e "state.myPage = context.pages().find(p => p.url() === 'about:blank') ?? context.newPage();"
   ```

4. **React Component Inspection:**
   Get the nearest React component name, parent hierarchy, sanitized props, and source file locations for a given locator.
   ```bash
   playwriter -e "const info = await getReactComponentInfo({ locator: page.locator('button.submit') }); console.log(JSON.stringify(info))"
   ```
   Returns `null` for non-React elements.

5. **Visual Labels (Fallback):**
   If the accessibility snapshot isn't enough to understand spatial layout, use Vimium-style visual labels.
   ```bash
   playwriter -e "screenshotWithAccessibilityLabels({ page })"
   ```

6. **Network Interception:**
   Instead of scraping the DOM, intercept API responses directly.
   ```bash
   playwriter -e "state.responses = []; page.on('response', async res => { if (res.url().includes('/api/')) state.responses.push(await res.json()) })"
   ```

7. **Page diagnostics via `getLatestLogs()` (v0.3.0+) — preferred over manual console listeners:**
   Returns buffered console logs and page errors (persisted across navigations, so hydration/redirect/startup errors are not lost). With `sinceLastCall: true`, later calls return only new entries.
   ```bash
   playwriter -s 1 -e 'console.log(await getLatestLogs({ page, sinceLastCall: true }))'
   ```

8. **Headless mode (v0.4.0+) — no extension or visible browser needed:**
   ```bash
   playwriter browser install                 # one-time: download Chrome for Testing
   playwriter session new --browser headless  # launch headless Chrome
   ```
   Multiple headless sessions share one Chrome process with isolated contexts. Useful for CI or servers; for normal use, prefer the extension (real session, no bot detection).

---

## Important Notes (v0.4.0)

- **Absolute paths required for saved artifacts** — `page.screenshot({ path })`, `page.pdf({ path })`, etc. must use absolute paths. Playwright resolves them outside the sandboxed `fs`, so relative paths will fail silently or write to unexpected locations.
- **Security** (since v0.2.0) — All endpoints (including loopback `/cli/*`) require a token. Under tunnel setups (ngrok, cloudflared), every request arrives from localhost — the previous bypass was effectively no-auth. Ensure `--token` is passed for remote subcommands (`session new`, `session list`, etc.).
- **Auto-page creation is ON by default** (since v0.3.1) — MCP/CLI sessions create a blank Playwriter-enabled tab when no targets are available; agents can start immediately. Set `PLAYWRITER_AUTO_ENABLE=false` to disable.
- **CDP logs rotate automatically** (since v0.3.0) — `~/.playwriter/cdp.jsonl` is capped at 10,000 entries (tune with `PLAYWRITER_CDP_LOG_MAX_ENTRIES`).
- **Cloud browser sessions** (v0.4.0, paid) — `playwriter session new --browser cloud` spins up stealth Chromium VMs with residential proxies (`--proxy us`); auth via `playwriter cloud login` or `PLAYWRITER_API_KEY` for CI. Not needed for local workflows.

---

## Source

- GitHub: https://github.com/remorses/playwriter
- Website: https://playwriter.dev/
