# MSFS 2024 on Linux: DLSS + DLSS Frame Generation on RTX 30

DLSS Super Resolution, DLSS Frame Generation up to 6x, DLSS Neural Rendering and ghost-free glass cockpit screens for **Microsoft Flight Simulator 2024** on **Linux** with an **NVIDIA RTX 30** card, running under [Flightdeck](https://github.com/marselnenaj/flightdeck-msfs-2024-linux-xbox).

Frame generation on RTX 20/30 comes from the `dlssg_sm86` mod in [DLSS Unlocked](https://github.com/ShyVortex/dlss-unlocked). On Windows that works out of the box. Under Wine it does not, because of missing pieces in the NvAPI and CUDA layers. This repository adds them:

- **`src/nvshim.c`**: an NvAPI shim (`nvapi64.dll`) that
  - gives NVIDIA's NGX runtime and the frame-generation mod the real [dxvk-nvapi](https://github.com/jp7677/dxvk-nvapi), and gives the game, Streamline and OptiScaler fixed answers that they start up with;
  - implements NvAPI's CU interface (`NvAPI_D3D12_CreateCuModule`, `CreateCuFunction`, `LaunchCuKernelChain[Ex]`, `DestroyCu*`). DLSS Frame Generation 310.9 needs it, and dxvk-nvapi does not have it yet.
- **`glass-fix/`**: a Wine build of the [Glass Cockpit DLSS Fix](https://github.com/IFreemz/msfs2024-glass-cockpit-dlss-fix) (GPL-3.0), which redraws the cockpit screens after DLSS so changing numbers do not ghost. The official release does not work under Wine; this folder holds the patch and a build script that fetches the upstream source.
- **`install.sh`**: puts everything in place and backs up every file it replaces.
- **`config/`**: the OptiScaler, DXVK and Wine settings that work.

No NVIDIA, Microsoft or OptiScaler files are included. You get them from their original sources (see [What you need](#what-you-need)).

## Status

| Feature | Status |
|---|---|
| DLSS Super Resolution | works |
| DLSS Frame Generation 2x–6x (`dlssg_sm86`) | works, 6x tested |
| DLSS Neural Rendering | works, on at start (Original model, Cinematic, 50 % model resolution; see [Limits](#limits)) |
| DLSS preset | M forced for every mode |
| Glass cockpit screens without DLSS ghosting | works (`glass-fix/`) |

Tested on one system:

| | |
|---|---|
| GPU | RTX 3080 10 GB |
| Driver | 615.78.08 |
| Distribution | CachyOS, kernel 7.3, KDE Plasma (Wayland) |
| Flightdeck | 0.3.8, Wine 11.0 runner |
| DLSS Unlocked | NR-v0.9.81 (OptiScaler 0.9.81, dlssg_sm86 0.4.1) |
| DLSS runtimes | 310.9.16 (shipped with MSFS 2024) |

Other RTX 20/30 cards, drivers and distributions are untested. Steam/Proton is not supported by `install.sh`. The shim itself is not Flightdeck-specific.

## What you need

| What | Where it comes from |
|---|---|
| MSFS 2024 installed and started once with Flightdeck | Flightdeck. MSFS itself ships `nvngx_dlss.dll`, `nvngx_dlssg.dll` (310.9.16) and Streamline. |
| NVIDIA Linux driver with `/usr/lib/nvidia/wine/nvngx.dll` | your distribution (`nvidia-utils`) |
| **DLSS Unlocked** standalone zip, e.g. `dlss-unlocked-standalone-NR-v0.9.81.zip` | [DLSS Unlocked releases](https://github.com/ShyVortex/dlss-unlocked/releases). Download the zip; do not extract it into the game yourself. |
| CUDA bridge `nvcuda.dll.so` (nvidia-libs) | **Proton-CachyOS** (Arch/CachyOS package `proton-cachyos-slr`, or the Proton-CachyOS release in `~/.steam/root/compatibilitytools.d/`). `install.sh` finds it there, or pass `--nvcuda <path>`. |
| mingw-w64 (`x86_64-w64-mingw32-gcc`) | your distribution (`mingw-w64-gcc` on Arch) |
| `git`, `curl`, `unzip`, `python3`, `nvidia-smi` | your distribution |

## Install

The sim must be closed.

```sh
git clone https://github.com/stratte89/msfs24-cachyos-linux-dlss-rtx30
cd msfs24-cachyos-linux-dlss-rtx30
bash install.sh --dlss-unlocked ~/Downloads/dlss-unlocked-standalone-NR-v0.9.81.zip
```

`install.sh`:

1. Builds `build/nvapi64.dll` from `src/nvshim.c`, and `build/glass-fix/winmm.dll` with `glass-fix/build.sh` (downloads the upstream glass fix source; skip with `--no-glass-fix`).
2. Copies into the game folder (`~/.local/share/flightdeck/games/msfs2024`):
   - from the DLSS Unlocked zip: `dxgi.dll` as `version.dll`, `OptiScaler/`, `nvngx_dlssnr.dll`, `nvngx.dll_dlssnr.dll`, `Licenses/`
   - from the driver: `nvngx.dll`
   - from `config/`: `OptiScaler.ini` (filled with your GPU's name and PCI ID, set read-only) and `dxvk.conf`
   - the glass fix as `winmm.dll`
3. Copies into the prefix's `system32`:
   - `nvapi64.dll` (the shim)
   - `nvapi64_dxvk.dll` (dxvk-nvapi from the Flightdeck runner)
   - `nvcuda.dll` (the CUDA bridge)
4. Imports `config/wine.reg`:
   - DLL overrides `version` and `nvapi64` = native,builtin
   - NGXCore `FullPath`
   - `winmm` = native,builtin for `FlightSimulator2024.exe` only (glass fix)
   - `VKD3D_CONFIG=no_upload_hvv` in the Wine user environment: vkd3d-proton keeps upload heaps in system RAM instead of Resizable-BAR VRAM, which frees video memory
5. Sets `FrameGeneration NONE` in `UserCfg.opt`.

Replaced files go to `~/.local/share/msfs2024-linux-dlss-rtx30/backup-<date>/`.

Other locations: set `MSFS_GAME_DIR`, `MSFS_PREFIX` or `FLIGHTDECK_DATA`.

Uninstall: `bash install.sh --uninstall`. This restores the latest backup; the registry overrides stay.

## In the sim

1. Graphics → **Anti-Aliasing: DLSS**. Quality mode is a good balance with neural rendering.
   - **Set DLSS mode, frame generation and every other graphics option in the main menu, before loading a flight.** Changing them in flight rebuilds buffers; on a 10 GB card that spills video memory into system RAM and locks the sim at about 10 fps (or loses the GPU device) until a restart.
2. Start the sim with **Frame Generation off**. The shim switches a saved "DLSS Frame Generation" back to off at every start, because starting with it on can crash the GPU.
3. Load into a flight, then set Frame Generation and the multiplier in the sim's graphics menu.
   - The game creates frame generation only in flight, a minute or two after loading. Expect one short stall when it starts.
   - Pick a multiplier that matches your monitor: on 60 Hz, 2x is enough. 3x and higher only help on high-refresh monitors.
4. OptiScaler's menu is **Insert**.
   - It can look dark while frame generation or another overlay (ReShade) is active.
   - Settings changed there are not saved, because `OptiScaler.ini` is read-only. Edit the file to make a change permanent.
   - Neural rendering, its model, mip bias and the DLSS preset come from `OptiScaler.ini` (`[DlssNr]`, `[Mipmap]`, `[DLSS]`). Change them there, not in the menu during a flight.
5. Glass cockpit fix: on automatically. Ctrl+Shift+F6 shows its status (`Working: fixing N screens`), Ctrl+Shift+F11 tints the fixed screens green, Ctrl+Shift+F9 switches it off and on.

## Check that it works

| Where | What to look for |
|---|---|
| OptiScaler menu (Insert) | upscaler **DLSS**, not FSR 2.1.2 |
| `<prefix>/drive_c/users/steamuser/AppData/Local/Temp/nvshim5.log` | `route ccfffc10 -> real for version.dll`; in flight `CU Kernel_... -> cubin shader 0` |
| `<game>/OptiScaler/dlssg_sm86/dlssg_sm86/logs/dlssg_sm86.log` | `"event":"evaluate"` with `"failed_launches_total":0` |
| `<game>/glass-cockpit-dlss-fix-status.txt` | `Working: fixing N screens` |
| `journalctl -k \| grep Xid` | nothing new |

## Troubleshooting

| Symptom | Fix |
|---|---|
| OptiScaler shows FSR 2.1.2 | Check that the shim is installed (`nvshim5.log` exists). OptiScaler needs NvAPI GPU information, otherwise it silently replaces DLSS with FSR. |
| `dlssg_sm86.log`: `Missing cuInit` | `system32/nvcuda.dll` is the Wine stub. Re-run `install.sh` with `--nvcuda`. |
| Sim freezes when pressing Insert | `OverlayMenu = false` must be in `OptiScaler.ini`. |
| Frame generation missing from the sim's menu | `SpoofHAGS = true`, `[FrameGen] External = true`, `AmpereMfgMode = External`. |
| Locked at ~10 fps after changing settings | Video memory is full ("Memory allocation failed, falling back to system memory" in the game log). Restart the sim. Neural Rendering and 6x frame generation need a lot of VRAM on 10 GB cards. |
| Cockpit screens still ghost | `glass-cockpit-dlss-fix-status.txt` names the step that fails. `Anti-Aliasing` must be DLSS or FSR. See `glass-fix/README.md` for the Wine-specific skip reasons. |
| Everything gone after a Flightdeck repair | Re-run `install.sh`. |

## Limits

- **Neural Rendering** on an RTX 3080 (model GPU time per frame): Original model at full 1440p about 45 ms, small FP8 model about 26 ms, Original at Quality render size (1706×960) about 18 ms, at 50 % model resolution about 13–14 ms. Pick the model in `OptiScaler.ini`; switching models in flight fills video memory.
- **Video memory**: DLSS + frame generation + neural rendering + the glass fix fit in 10 GB with texture resolution Low. ReShade with AtmosphereMod added 0.5–0.9 GB and pushed it over the limit.
- **Glass fix CPU cost** under Wine: about 4–5 ms per frame.
- The shim reports some fixed values to the game and Streamline:
  - GPU architecture Ada (needed for Streamline to offer DLSS Frame Generation)
  - driver 615.78
  - 10 GB memory
  - PCI IDs and name from the real adapter
- Dynamic multi-frame generation is not available with dlssg_sm86 0.4.1.

## How it works

See [docs/how-it-works.md](docs/how-it-works.md).

## Credits

- [OptiScaler](https://github.com/optiscaler/OptiScaler) and [DLSS Unlocked](https://github.com/ShyVortex/dlss-unlocked)
- [dlssg_sm86](https://github.com/sdli1995/dlssg_for_sm86) by sdli1995
- [dxvk-nvapi](https://github.com/jp7677/dxvk-nvapi)
- nvidia-libs (CUDA bridge) via Proton-CachyOS
- [Flightdeck](https://github.com/marselnenaj/flightdeck-msfs-2024-linux-xbox)
- [Glass Cockpit DLSS Fix](https://github.com/IFreemz/msfs2024-glass-cockpit-dlss-fix) by IFreemz

## License

MIT for the files in this repository (see `LICENSE`), except `glass-fix/`, which modifies GPL-3.0 code and is GPL-3.0 (`glass-fix/LICENSE`). Not affiliated with NVIDIA, Microsoft, Asobo or the projects above. DLSS, GeForce and RTX are trademarks of NVIDIA.
