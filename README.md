<img width="640" height="640" alt="RallyLogo" src="https://github.com/user-attachments/assets/d3519b5c-a137-4a76-ac6e-d33b8a07fffd" />


RallyHelper is a lightweight, modern and reliable world buff tracker for Turtle WoW.  
It focuses on **accuracy**, **verification**, and **zero spam**, making it a clean alternative to older addons like PizzaWorldBuffs.

---


## ✨ Features

### ✔ Verified World Buff Detection
RallyHelper only accepts world buff events when they are confirmed by multiple RallyHelper users.  
This prevents:
- fake timers  
- manipulated timestamps  
- false positives  
- addon spam  

### ✔ Unconfirmed Buffs (NEW in v1.0.1)
When only one source reports a buff, RallyHelper now shows a **preliminary timer** marked as:

```
unconfirmed (12s ago)
```

This helps new users understand that the addon is working even before enough RallyHelper users are online.

### ✔ Zero Channel Spam
RallyHelper sends **only real events**, never:
- heartbeats  
- version checks  
- periodic updates  
- map sync  
- debug spam  

This keeps the RallyHelper channel clean and efficient.

### ✔ Anonymous User Count (NEW)
Use:

```
/rally users
```

to see how many RallyHelper users are currently active.  
This is fully anonymous and requires no extra messages.

### ✔ DMF Detection
Automatically detects Darkmoon Faire NPCs and records the last seen location.

### ✔ Clean UI with pfUI Support
Resizable, movable, minimalistic UI with optional pfUI skinning.

---

## 📦 Installation

1. Download the latest release ZIP  
2. Extract it into your `Interface/AddOns` folder  
3. Ensure the folder name is **RallyHelper**  
4. Restart the game

---

## 🧭 Commands

```
/rally
```
Toggle the UI.

```
/rally status
```
Print timers in chat.

```
/rally share
```
Share timers to chat.

```
/rally users
```
Show number of active RallyHelper users (anonymous).

```
/rally lock
```
Lock or unlock the UI.

```
/rally reset
```
Reset UI position and settings.

---

# 📝 **RallyHelper 1.2 – Changelog**

## 🚀 New Features

### **✔ Timer Request System (REQ / TIMER\_*)**
RallyHelper can now actively request missing timers from other players in the channel.

- New event type: `REQ`
- Players with confirmed timers automatically respond with `TIMER_*` events  
- Supports Ony, Nef, ZG, DMF, and Warchief’s Blessing  
- `/rally request` command added  
- Automatic timer request on login

### **✔ Secure 5‑Player Verification for Sync Events**
To prevent manipulation or incorrect data, TIMER‑based sync events now require **5 independent confirmations** before being accepted.

- Yell‑based events → require 2 confirmations  
- Sync‑based events → require 5 confirmations  
- Prevents fake timers, ghost timers, and single‑source manipulation  
- Ensures only widely‑agreed data is adopted

### **✔ Defensive String Handling**
RallyHelper now uses safe local copies of Lua string functions:

- `strmatch`
- `strfind`
- `strlower`
- `strsub`

This protects the addon from other addons that overwrite or break global string functions.

---

## 🔧 Improvements

- More robust channel parsing and event handling  
- Cleaner unconfirmed‑event tracking  
- More reliable UI updates after confirmed events  
- Improved DMF detection logic  
- Sanitized outgoing messages to avoid malformed data  
- Better resilience in “hostile” addon environments

---

## 🐛 Bug Fixes

- Fixed issues caused by addons that modify `string.lower` or `string.find`  
- Fixed rare cases where ZG events were not stored correctly  
- Fixed UI not updating after certain confirm events  
- Fixed minimap button drag behavior on unusual UI scales

---

## ⚠️ Known Incompatibility: LazyPig

Some users have reported that **LazyPig** interferes with RallyHelper’s functionality.

### Observed symptoms:
- Timers not being shared  
- Confirm events not being processed  
- REQ/TIMER sync not working reliably  

### Possible cause:
LazyPig modifies or hooks into:

- global `string.*` functions  
- chat event handlers  
- channel parsing logic  

These modifications can disrupt RallyHelper’s event parsing and verification logic.

### Recommendation:
If RallyHelper does not synchronize timers correctly, try **disabling LazyPig**.  
This issue may be caused either by LazyPig itself or by the combination of LazyPig’s hooks with RallyHelper’s new defensive code.

---

## ❤️ Final Notes
RallyHelper remains intentionally lightweight, transparent, and community‑friendly.  
All new features are designed to be safe, predictable, and resistant to manipulation — without relying on server time tricks or hidden logic.


---


## 🙌 Inspiration

RallyHelper was inspired by the long‑standing PizzaWorldBuffs addon, which served the community for many years.  
This project builds on that idea with a modern, verified and spam‑free approach tailored for Turtle WoW.


## ❤️ Support

RallyHelper is a free community addon.  
If you enjoy it and want to support development, you can do so here:

https://ko-fi.com/weirdpuyppy94

Any support is greatly appreciated.
I’m currently going through a financially challenging period, and contributions help me continue maintaining and improving this project.

Support is completely optional and has no impact on features or updates.

---

## 📜 License

MIT License  
Free to use, modify and share.
```

