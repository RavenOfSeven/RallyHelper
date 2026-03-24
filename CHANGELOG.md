# Changelog

All notable changes to this project are documented here.

---

## [1.3.7] - 2026-03-24 — Stability & Robustness Release

**Summary**  
Stability-focused patch that hardens timer sync, prevents outlier timestamps from breaking timers, and makes sound playback and user notifications more robust and configurable.

### Fixed
- **Robust timer selection** — `TIMER_*` responses are now chosen by the *adjusted* timestamp closest to `now`, preventing single outliers from overwriting correct timers (stops multi‑hour jumps caused by bad client clocks).
- **Timestamp sanity checks** — `AcceptEvent` rejects absurd timestamps (older than **30 days** or more than **1 hour** in the future).
- **Table / length safety** — replaced fragile `#table` checks with safe `next()` checks to avoid runtime errors on non‑dense tables.
- **Scoping & stability fixes** — cleaned up local/global scoping issues and removed duplicate/conflicting definitions that could cause runtime errors in some environments.

### Changed / Improved
- **Hardened sound handling**
  - Prefer `PlaySoundFile` (more reliable on Classic/private builds).
  - Use `PlaySound`/`SOUNDKIT` only when available; all calls wrapped in `pcall`.
  - Added debug output for sound attempts when `DB.debug = true`.
- **Message versioning** — outgoing timer messages include an addon version tag (`vN`); incoming messages parse the version and prefer newer/compatible senders where configured.
- **Ignore list** — new `/rallyignore add|remove|list <name>` to temporarily block noisy or buggy senders.
- **Toast configuration** — new `DB.toastMode` with values `chat`, `ui`, `none`; added `/rallytoast` to switch modes.
- **DB migration** — `EnsureDB()` initializes new keys safely and does not overwrite existing user preferences.

### Notes
- Recommend all channel users update to **v1.3.7** for best results.

---

## [1.3.6] - 2026-03-22 — Stability & Vanilla Compatibility Update

### Fixed
- Fixed a critical issue where `SetVerticalScroll(offset)` caused UI errors when opening the Unconfirmed window (slider events fired before ScrollFrame initialization).
- Fixed a syntax error (`end expected near <eof>`) in `CreateUnconfirmedUI()`.
- Fixed `RallyHelper_ToggleUI` being `nil` due to file load failure.
- Fixed Vanilla/Turtle incompatibility in `CreateSizeUI()` (use full 5-argument `SetPoint` form).
- Fixed potential crash when the Unconfirmed list was empty by clamping slider values.
- Fixed negative scroll offsets in Vanilla by enforcing safe clamping.
- Fixed race condition where the ScrollFrame could be accessed before its ScrollChild existed.

### Stability improvements
- Defensive slider logic: ignore nil offsets, clamp negative values, check ScrollFrame + ScrollChild before scrolling.
- MouseWheel handler now safely checks for slider existence.
- Unconfirmed UI loads reliably even with zero events.
- Removed duplicate local variables and cleaned up function structure.

---

## [1.3.0] — Unconfirmed UI Rework

### New
- Complete Unconfirmed Events UI:
  - ScrollFrame with slider
  - Filter checkboxes (Alliance, Horde, ZG, WB)
  - Dynamic event list
  - pfUI-compatible layout
- Safer handling for unconfirmed world buff events.

### Fixed
- Events now sort correctly by timestamp.
- Enforced a maximum of 20 entries to prevent overflow.
- Improved layout consistency and text alignment.

---

## [1.2.0] — Sync & RHGlobal Stabilization

### New
- Introduced `RHGlobal.Unconfirmed` as persistent global storage.
- Added support for solo players without LFT channel.
- Added dedicated `RallyDebug` channel for clean debugging.

### Fixed
- Resolved sync issues caused by TurtleWoW system channels.
- Improved event parsing and validation.
- Ensured events are received even when not in LFT.

### Cleanup
- Removed outdated sync logic.
- Unified event handling and storage.

---

## ⚠️ Known incompatibility: LazyPig

Some users report LazyPig interferes with RallyHelper (timers not shared, confirmations not processed). If you experience sync issues, try disabling LazyPig.

---

## Contributing

Please open issues or pull requests on GitHub. Include debug logs (`DB.debug = true`) when reporting sync or timer issues.

---
