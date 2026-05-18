# Browser-Based Visual QA -- gstack's Playwright Automation Layer

## Source
Derived from `BROWSER.md` in the gstack repository (github.com/garrytan/gstack).

---

## Architecture

gstack's browser layer is a compiled CLI binary (~58MB) that talks to a persistent local Chromium daemon over HTTP. The daemon does the real work via Playwright's API. Everything that was a Chrome MCP server in early days now happens through plain stdout. No JSON-schema framing, no protocol negotiation, no persistent WebSocket.

Key architectural decisions:
- **CLI over MCP:** Claude's Bash tool already exists. A CLI printing to stdout is the simplest possible interface. MCP adds context bloat (every call includes full JSON schemas), connection fragility (WebSocket drops), and unnecessary abstraction.
- **0 context token overhead:** Every MCP call costs 1500-2000 tokens in schema/protocol framing. gstack burns zero. In a 20-command browser session, MCP burns 30,000-40,000 tokens on protocol alone.
- **~100-200ms per call** after the first (which takes ~3s to spin up the daemon).

### Daemon Lifecycle
1. First call: CLI spawns daemon in background, daemon launches headless Chromium via Playwright, picks random port (10000-60000), generates bearer token, writes state file (chmod 600). ~3 seconds.
2. Subsequent calls: CLI reads state file, sends HTTP POST with bearer token, prints response. ~100-200ms.
3. Idle shutdown: after 30 minutes of no commands, daemon shuts down.
4. Crash recovery: if Chromium crashes, daemon exits immediately. CLI detects dead daemon on next call and starts fresh.

---

## QA-Relevant Commands

### Visual and Screenshot Commands

**`screenshot [--selector <css>] [--viewport] [--clip x,y,w,h] [--base64] [sel|@ref] [path]`**
Five modes:
- Full page (default): `page.screenshot({ fullPage: true })`
- Viewport only: `--viewport` flag
- Element crop: `--selector` flag, CSS selector positional, or `@e`/`@c` ref
- Region clip: `--clip x,y,w,h`
- Base64: returns `data:image/png;base64,...`

`--base64` composes with `--selector`, `--clip`, `--viewport`. Mutual exclusion rules enforced between `--clip` + selector, `--viewport` + `--clip`.

**`responsive [prefix]`**
Three screenshots in one call: mobile (375x812), tablet (768x1024), desktop (1280x720). Saves as `{prefix}-mobile.png`, `{prefix}-tablet.png`, `{prefix}-desktop.png`. Use this for automated responsive design testing.

**`prettyscreenshot [--scroll-to <sel|text>] [--cleanup] [--hide <sel>...] [path]`**
Combines cleanup (removes cookie banners, ads, sticky elements, social widgets) + scroll + element hide in one call. Perfect for clean before/after visual comparison.

**`viewport [<WxH>] [--scale <n>]`**
Set viewport size + optional deviceScaleFactor (1-3 cap). `--scale N` alone keeps current size but changes pixel density. Scale changes trigger context recreation, invalidating `@e`/`@c` refs.

**`diff <url1> <url2>`**
Text diff between two URLs. Useful for comparing staging vs production content.

### Snapshot System: Ref-Based Element Selection

The browser's key innovation -- no DOM mutation, no injected scripts. Built on Playwright's accessibility tree API.

**`snapshot [-i] [-c] [-d N] [-s sel] [-D] [-a] [-o path] [-C]`**
- `-i`: interactive only (clickable, fillable elements)
- `-c`: compact output
- `-d N`: depth limit
- `-s <sel>`: scope to a CSS selector
- `-D` (diff): stores snapshot as baseline; next `-D` call returns unified diff showing what changed. Critical for verifying that actions (click, fill) actually worked.
- `-a` (annotate): injects temporary overlay divs at each ref's bounding box, takes screenshot with ref labels visible, then removes overlays. Use with `-o <path>` for output.
- `-C` (cursor-interactive): scans for non-ARIA interactive elements (divs with `cursor:pointer`, `onclick`, `tabindex>=0`) using `page.evaluate`. Assigns `@c1`, `@c2`... refs with deterministic CSS selectors.

**How @ref works:**
1. `page.locator(scope).ariaSnapshot()` returns YAML-like accessibility tree
2. Parser assigns refs (`@e1`, `@e2`, ...) to each element
3. For each ref, builds a Playwright `Locator` (using `getByRole` + nth-child)
4. Ref-to-Locator map stored on BrowserManager
5. Later commands like `click @e3` look up the Locator and call `locator.click()`

**Ref staleness detection:** Before using any ref, `resolveRef()` runs an async `count()` check. If element count is 0 (SPA DOM mutation), it throws immediately (~5ms) telling the agent to re-run `snapshot`.

### Interaction Commands

**`click <sel|@ref>`** -- Click element by CSS selector or ref

**`fill <sel> <val>`** -- Fill input

**`select <sel> <val>`** -- Select dropdown option (value, label, or visible text)

**`hover <sel>`** -- Hover element

**`type <text>`** -- Type into focused element

**`press <key>`** -- Playwright keyboard key (case-sensitive): `Enter`, `Tab`, `ArrowUp`, `Shift+Enter`, `Control+A`, etc.

**`scroll [sel|@ref]`** -- Scroll element into view, or jump to page bottom if no selector

**`upload <sel> <file> [...]`** -- Upload file(s)

**`dialog-accept [text]`** -- Auto-accept next alert/confirm/prompt; text is sent for prompts

**`dialog-dismiss`** -- Auto-dismiss next dialog

### Inspection Commands

**`text [sel]`** -- Clean page text (or scoped to selector). Primary way to verify content changes.

**`html [sel]`** -- innerHTML, or full page HTML if no selector

**`accessibility`** -- Full ARIA tree. How the page reads to screen readers.

**`forms`** -- Form fields as JSON. Structure, types, labels, placeholders.

**`is <prop> <sel|@ref>`** -- State check: visible, hidden, enabled, disabled, checked, editable, focused. Used to verify interactive element states.

**`css <sel> <prop>`** -- Computed CSS value. Used to verify design token application.

**`attrs <sel|@ref>`** -- Element attributes as JSON.

**`console [--clear|--errors]`** -- Captured console messages. All console/network/dialog events flow into O(1) circular buffers (50,000 capacity each).

**`network [--clear]`** -- Captured network requests.

**`dialog [--clear]`** -- Captured dialog messages.

**`cookies`** -- All cookies as JSON.

**`perf`** -- Page load timings. Navigation timing, paint timing, FCP, LCP, TTFB.

**`inspect [sel] [--all] [--history]`** -- Deep CSS via CDP. Full rule cascade with specificity, computed styles, box model, and (with `--history`) every CSS modification made via `$B style`.

**`ux-audit`** -- Page structure for behavioral analysis: site ID, nav, headings (capped 50), text blocks, interactive elements (capped 200). Used by /qa and /design-review for cheap coverage maps.

### Style Modification and Cleanup

**`style <sel> <prop> <val>`** -- Modify CSS property with undo support

**`style --undo [N]`** -- Undo last N style changes. Enables safe CSS experimentation.

**`cleanup [--ads|--cookies|--sticky|--social|--all]`** -- Remove page clutter. Remove cookie banners, ads, sticky headers, social widgets for clean screenshots.

### Capture Commands

Console, network, and dialog events are captured in real-time in-memory O(1) circular buffers. The `console`, `network`, and `dialog` commands read from in-memory buffers (not disk).

Dialogs (alert, confirm, prompt) are auto-accepted by default to prevent browser lockup. `dialog-accept <text>` controls prompt response text.

### Responsive Testing

`responsive [prefix]` generates three screenshots in one call: mobile (375x812), tablet (768x1024), desktop (1280x720). Saves as `{prefix}-mobile.png`, `{prefix}-tablet.png`, `{prefix}-desktop.png`.

For retina-quality screenshots, use `viewport --scale <n>` (1-3) before `screenshot`. Scale changes trigger context recreation, invalidating refs.

---

## The Productivity Loop: /scrape + /skillify

gstack's compounding layer. The first time you scrape a page, the agent drives it step-by-step (~30s). The second time, a codified browser-skill runs in ~200ms.

### /scrape <intent>
- **Match path (~200ms):** Agent runs `$B skill list`, semantically matches intent against each skill's triggers/description/host, runs `$B skill run <name>` if confident match exists.
- **Prototype path (~30s):** No match, agent drives the page with commands, returns JSON, suggests `/skillify`.
- **Mutating refusal:** Verbs like submit, click, fill are blocked. /scrape is read-only by contract.

### /skillify
Codifies the most recent successful /scrape into a permanent browser-skill. Three locked contracts:
1. **Provenance guard:** Walks back agent turns for a clearly-bounded /scrape result. Refuses if cold.
2. **Synthesis:** Extracts only the final-attempt commands that produced accepted JSON, plus user's intent string.
3. **Atomic write:** Stages to temp, runs `$B skill test`, only renames into final path on test pass + user approval. Test fail or rejection: entire staging directory is deleted.

### Browser-Skill Anatomy
```
browser-skills/<name>/
  SKILL.md                   # frontmatter + prose contract
  script.ts                  # deterministic Playwright-via-browse-client logic
  _lib/browse-client.ts      # vendored SDK (~3KB, byte-identical to canonical)
  fixtures/<host>-<date>.html # captured page for fixture-replay tests
  script.test.ts             # parser tests against fixture (no daemon required)
```

### Three-Tier Storage
- **Project:** `<project>/.gstack/browser-skills/<name>/` -- committed or gitignored
- **Global:** `~/.gstack/browser-skills/<name>/` -- per-user, all projects
- **Bundled:** `<gstack-install>/browser-skills/<name>/` -- ships with gstack, read-only

---

## Visual QA Workflow Patterns

### Pattern 1: Full Design Audit
```
$B goto <url>
$B screenshot first-impression.png
$B snapshot -i -a -o annotated.png             # annotated interactive elements
$B responsive responsive                        # 3 screenshots at key breakpoints
$B console --errors                             # capture JS errors
$B perf                                         # performance baseline
$B js "..."                                     # extract design tokens from rendered page
```

### Pattern 2: Before/After Fix Verification
```
# Before
$B goto <url>
$B screenshot before.png

# Apply fix in source code, rebuild/reload

# After
$B goto <url>
$B screenshot after.png
$B snapshot -D                                  # diff to verify what changed
$B console --errors                             # verify no new errors
$B is visible @e12                              # verify specific element state
```

### Pattern 3: Interaction Flow Testing
```
$B goto <url>
$B snapshot -i                                  # baseline snapshot
$B click @e3                                    # perform action
$B snapshot -D                                  # diff to verify what changed
$B click @e15                                   # next action
$B snapshot -D                                  # verify
$B is visible ".success-message"                # verify outcome
```

### Pattern 4: Form Testing
```
$B goto <url>
$B snapshot -i                                  # see all form fields
$B fill @e7 "test@example.com"                  # fill by ref
$B fill "#password" "test123"                   # fill by selector
$B click ".submit-button"
$B snapshot -D                                  # verify validation/submission result
$B is visible ".error-message"                  # verify error state
```

### Pattern 5: Responsive Visual QA
```
$B viewport 375x812
$B goto <url>
$B screenshot mobile.png
$B is hidden ".desktop-nav"                     # verify mobile nav is hidden
$B is visible ".hamburger-menu"                 # verify mobile menu exists
$B click ".hamburger-menu"                      # open menu
$B is visible ".mobile-nav"                     # verify it opened
```

### Pattern 6: Design Token Verification
```
$B goto <url>
$B js "getComputedStyle(document.documentElement).getPropertyValue('--color-primary')"
$B css "h1" "font-family"                       # verify heading font
$B css "body" "font-size"                       # verify body text size >= 16px
$B js "JSON.stringify([...document.querySelectorAll('a,button,input,[role=button]')].filter(e=>{const r=e.getBoundingClientRect();return r.width<44||r.height<44}).slice(0,20))"
                                                 # touch target audit
```

---

## Real-Browser Mode (Headed Chromium)

`$B connect` launches a visible "GStack Browser" (rebranded Chromium) with the Side Panel extension auto-loaded. Every command ticks through the visible window in real time.

When to use:
- QA testing where you want to watch Claude click through the app
- Design review where you need to see exactly what Claude sees
- Debugging where headless behavior differs from real Chrome
- Demos where you're sharing your screen

When in real-browser mode, /qa and /design-review automatically skip cookie import prompts and headless workarounds -- the headed browser already has whatever session was logged in.

### Side Panel Extension Features
- **Activity feed:** Scrolls every browse command (name, args, duration, status, errors) in real time
- **Refs tab:** Shows current `@ref` list so you can see what Claude is targeting
- **CSS Inspector:** Click any element to see full CSS rule cascade, box model, modification history
- **Terminal pane:** Live `claude -p` PTY you can type into directly from the sidebar
- **"Send to Code" button:** Injects CSS inspection results into the Claude PTY

---

## Performance Characteristics

| Tool | First call | Subsequent calls | Context tokens per call |
|------|-----------|------------------|-------------------------|
| Chrome MCP | ~5s | ~2-5s | ~2000 |
| Playwright MCP | ~3s | ~1-3s | ~1500 |
| **gstack browse** | **~3s** | **~100-200ms** | **0** |
| **gstack browse + codified skill** | **~3s** | **~200ms** | **0** |

The codified-skill path takes a 20-command browser session down to a single `$B skill run` call.

---

## Impact on React Code Generation Agents

### What to Adopt
1. **Screenshot-first QA loop:** Every design change should be verified with a before/after screenshot pair, not just "it looks right" assertions. Use responsive screenshots at minimum 3 breakpoints.
2. **Snapshot-diff for change verification:** After any interaction (click, fill, navigate), diff the accessibility snapshot to confirm the UI actually changed as expected.
3. **Design token extraction from rendered page:** Don't trust DESIGN.md -- extract actual rendered values using computed style queries.
4. **Touch target audit:** Every interactive element must be >= 44px. Extract and flag undersized elements.
5. **Console error capture:** No design change is complete without verifying zero new console errors.
6. **The codified skill pattern:** Deterministic browser flows that can be replayed in ~200ms. The second time you test a flow, it should be instant.
7. **Atomic fixes with before/after:** One commit per design fix. Before/after screenshot pair for every fix. Revert immediately if regression detected.

### What Makes gstack's Browser Approach Unique
- **0 context-token overhead:** The CLI-to-stdout pattern eliminates the massive context cost of MCP schemas
- **Ref-based element selection:** No fragile selectors, no DOM mutation -- accessibility tree refs that survive re-renders
- **Snapshot diffing:** Deterministic verification that interactions actually changed the page
- **Codifiable browser flows:** The first crawl costs 30s; the codified version costs 200ms
- **Real-browser mode with Side Panel:** Watch Claude work in real time with a live activity feed and CSS inspector
