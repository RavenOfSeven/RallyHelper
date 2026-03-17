# RallyHelper

**RallyHelper** shows timers and last-seen information for Onyxia, Nefarian, Zul'Gurub (ZG) and the Darkmoon Faire (DMF). The UI is movable, resizable and includes a scale slider so icons and text can be enlarged or reduced. The background fades on hover while text and icons remain visible.

## Features

- Onyxia / Nefarian timers for Alliance and Horde spawns
- ZG last drop timestamp
- DMF last seen timestamp including zone
- Warchief’s Blessing cooldown display
- Resizable window with Width / Height sliders
- Scale slider to change text and icon sizes
- Hover fade that affects only the background (text and icons stay visible)
- Movable window with position persistence across sessions

## Commands

- `RallyHelper_ToggleUI()` — Toggle the main RallyHelper window.
- `RallyHelper_ToggleSizeUI()` — Open the size/scale window (Width, Height, Scale sliders).
- `/reload` — Reload UI after installing/updating the addon.

Example:
```lua
/run RallyHelper_ToggleUI()
