# DAoC – Copilot Instructions

This repository is a personal toolkit for **Dark Age of Camelot** (specifically the [Eden](https://eden-daoc.net) free shard). It contains automation scripts, multiboxing configs, character templates, and game notes — no traditional build/test pipeline exists.

## Repository layout

| Path | Purpose |
|---|---|
| `sprintoMatic/` | AutoIt script that reads game memory via `NomadMemory.au3` and auto-presses the sprint key when the stamina addresses drop to 0 |
| `HKN/` | HotkeyNet scripts and config for multiboxing (broadcasting keystrokes to multiple game windows) |
| `macro_autoit/` | Standalone AutoIt macros for combat key sequences |
| `eden/` | Character template files (`.ini`/`.ign` per character per server version), crafting scripts, damage tables, game command notes |
| `eden/tp/` | Template planning files, one directory per class |
| `eden/craft/` | AutoIt spammer for crafting queues; `.txt` SC-Report exports |
| `eden/eld_dmg/` | Damage calc tables for Eldritch (AA × MoM combos) |
| `ui/` | UI skin packs and icon sets |
| `LotM/` | Legacy character saves (`.ini` = character config, `.ign` = ignore list) |

## Scripting languages used

- **AutoIt v3** (`.au3`) — primary scripting language for all automation
- **AutoHotkey** (`.txt` with AHK syntax, e.g. `scriptAHKskald.txt`) — hotkey loops with `Send`/`Sleep`
- **HotkeyNet** macro syntax (`.txt` files in `HKN/`) — `<Hotkey>`, `<SendwinSF>`, `<RenameWin>` directives

## Key conventions

### AutoIt scripts
- All AutoIt scripts target **AutoIt v3**; run them with `AutoIt3.exe <script>.au3` or compile with Aut2Exe.
- Scripts that require game memory access (`#include <NomadMemory.au3>`) must run as Administrator (`#RequireAdmin` is already set).
- `rename.au3` (in `eden/`) should be executed from **SciTE as admin** — there's a comment at the top of the file stating this.
- Configuration is read exclusively from `.ini` files via `IniRead`; settings are under the `[main]` section. Never hardcode addresses or keys inside `.au3` files.
- Memory addresses in `sprintoMatic/settings.ini` are hex values (`0x…`); update them after game patches.

### HotkeyNet (HKN)
- The master settings file is `HKN/hkn_settings.txt`; `bPartialWindowNameMatch = true` so window titles don't need to be exact.
- Multiboxing scripts use `<RenameWin "Dark Age of Camelot" CamelotN>` to disambiguate windows before broadcasting.
- `<sendwinSF>` sends keystrokes to a background window (no focus steal); `<SendwinSF>` (capital S) sends with focus.

### Character templates
- `.ini` files in `LotM/` and `eden/` follow the naming pattern `<CharacterName>-<BuildLevel>.ini`.
- `.ign` files follow `<CharacterName>-<ServerVersion>.ign` (143 = old server, 225 = newer patch, etc.).
- Template planning subdirectories in `eden/tp/` are named by class (e.g. `hunter`, `skald`, `valk`).

## Game-specific references

- Server: **Eden** (`https://eden-daoc.net`) — not live DAoC
- Useful in-game commands are documented in `eden/readme.md`
- SpellCraft cap: 37.5 requires at least 1001 skill; pre-dragon cap is 45, mini is 48
- Crafting grandmaster thresholds: SC 1049, fletching/weapon 1080, alc/armor/tailoring 1100
- Eldritch damage reference table: `eden/eld_dmg/readme.md` (AA × MoM × debuff combos)
- To fix double-click launcher issues after crash: delete `%LocalAppData%\Eden_DAoC`
