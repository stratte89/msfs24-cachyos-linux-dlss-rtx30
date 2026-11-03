# Glass Cockpit DLSS Fix — Wine build

[Glass Cockpit DLSS Fix](https://github.com/IFreemz/msfs2024-glass-cockpit-dlss-fix) by IFreemz redraws the cockpit screens after DLSS, so moving numbers no longer ghost. The official release does not work under Wine. This folder makes it work: a patch, two extra source files, and a build script.

**Licence:** the fix is GPL-3.0 (`LICENSE` in this folder). `wine.patch`, `proxy_exports.S`, `mingw_compat.h`, `extract_shaders.py` and `build.sh` are changes to it and are GPL-3.0 as well. The rest of this repository is MIT.

## Build

```sh
bash glass-fix/build.sh
```

Output: `build/glass-fix/winmm.dll`. The repository's `install.sh` runs this automatically unless `--no-glass-fix` is given.

| Step | Detail |
|---|---|
| Source | upstream commit `de97470989c5a322d4ed4192f69cc1948c228504` (git clone + checkout) |
| MinHook | commit `8af6b4acae5a9388fd742b56fa79ece89d96f823` |
| Shaders | taken from the official `glass-cockpit-dlss-fix-standalone.zip` v1.0.4 (SHA-256 `344b464e…7d980`, verified). The shader sources are identical between v1.0.4 and the pinned commit. The Arch/CachyOS `dxc` 1.10.2605 aborts on these shaders, so they are not recompiled. `extract_shaders.py` checks the order. |
| Compiler | mingw-w64 (`x86_64-w64-mingw32-g++`), static runtime, stripped |

Needs `git`, `curl`, `unzip`, `python3` and `mingw-w64-gcc`.

## What the patch changes

| Problem under Wine | Symptom in `glass-cockpit-dlss-fix.log` | Change |
|---|---|---|
| vkd3d-proton returns a new `ID3D12RootSignature` for an identical blob; Windows returns the same object. MSFS creates its display root signatures more than once, so the display pipeline and the draw bind different objects. | `skip reason=root_layout` on every screen draw | Root signatures are identified by an FNV-1a hash of their blob. Logs `root_signature duplicate content` and `root_layout detail`. |
| vkd3d-proton descriptor handles are encoded (odd addresses), not NVIDIA descriptor bytes. The fix compares descriptor bytes on NVIDIA. | `texture_not_recognised`, `descriptor_unreadable` | Descriptor tracking (the fix's path for other GPUs) is forced when `ntdll!wine_get_version` exists. Unreadable bytes no longer stop the tracking path. |
| GCC lays out overloaded virtual functions in declaration order, MSVC in reverse order per name. NGX parameter objects are MSVC-built. | `dlss_inputs_unsupported colour=0 output=0` | `NVSDK_NGX_Parameter` overloads declared in reverse order for non-MSVC builds (`ngx_interface.hpp`). |
| MSVC-only build parts | — | `__try` → VirtualQuery page check; `proxy_exports.asm` (MASM) → `proxy_exports.S` (GNU as); `mingw_compat.h` declares `ID3D12GraphicsCommandList8`–`10`; `__CRT_UUID_DECL` for the fix's COM classes. |

## Install

`install.sh` copies `winmm.dll` into the game folder and sets the Wine override `HKCU\Software\Wine\AppDefaults\FlightSimulator2024.exe\DllOverrides` `winmm = native,builtin` (`config/wine.reg`). The game folder already holds OptiScaler as `version.dll`, so the fix uses the `winmm.dll` name, as its README recommends.

The fix runs from sim start. Keys in the sim:

| Key | Action |
|---|---|
| Ctrl+Shift+F6 | status window (`Working: fixing N screens`) |
| Ctrl+Shift+F11 | green tint on every fixed screen |
| Ctrl+Shift+F9 | fix on/off |

Settings: `glass-cockpit-dlss-fix.ini` in the game folder (a known-good copy ships in `config/`).

## Known issues

- **All displays start shaking after a while.** The fix re-derives each screen's recorded draw position every frame and composites all screens through one shared jitter path; the default jitter mode (`jitter_positive=0`) can desync from the sim's jitter sequence — every composited screen then lands a pixel or two off in alternating directions, so all displays shake at once. Set `jitter_positive=1` in `glass-cockpit-dlss-fix.ini` (applies within a second, no restart). The `stable_edges`, `calm_glass`, `temporal_aa` and `dark_screen_fix` options did not address the shaking in testing.
- `skipped (screen doesn't match the sim's picture)` in the log marks a screen whose recorded texture failed the match for that frame — it falls back to the sim's raw upscale for that frame, and a screen riding the match boundary flickers between paths.

## Known

- CPU cost under Wine about 4–5 ms per frame (descriptor tracking).
- Tested with Fenix A320, OptiScaler 0.9.81, DLSS 310.9.16, DLSS-G via dlssg_sm86, neural rendering on.
- With ReShade + AtmosphereMod loaded the fix also works (descriptor tracking), but they add 0.5–0.9 GB VRAM.
