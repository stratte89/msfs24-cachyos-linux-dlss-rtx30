#!/usr/bin/env bash
# Installs DLSS Super Resolution, DLSS Frame Generation (RTX 20/30 via dlssg_sm86) and
# DLSS Neural Rendering for MSFS 2024 running under Flightdeck, plus the Glass Cockpit DLSS Fix (Wine build).
#
#   bash install.sh --dlss-unlocked <dlss-unlocked-standalone-NR-*.zip> [--nvcuda <nvcuda.dll.so>] [--no-glass-fix]
#   bash install.sh --uninstall
#
# The simulator must be closed. See README.md.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
FD="${FLIGHTDECK_DATA:-$HOME/.local/share/flightdeck}"
GAME="${MSFS_GAME_DIR:-$FD/games/msfs2024}"
PREFIX="${MSFS_PREFIX:-$FD/runtimes/msfs2024/local/msfs-prefix}"
SYS32="$PREFIX/drive_c/windows/system32"
USERCFG="$PREFIX/drive_c/users/steamuser/AppData/Roaming/Microsoft Flight Simulator 2024/UserCfg.opt"
STATE="${XDG_DATA_HOME:-$HOME/.local/share}/msfs2024-linux-dlss-rtx30"

die() { echo "error: $*" >&2; exit 1; }
say() { echo "== $*"; }

dlssu=""; nvcuda=""; uninstall=0; glass=1
while [ $# -gt 0 ]; do
    case $1 in
        --dlss-unlocked) dlssu=${2:?}; shift ;;
        --nvcuda) nvcuda=${2:?}; shift ;;
        --uninstall) uninstall=1 ;;
        --no-glass-fix) glass=0 ;;
        -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
        *) die "unknown option: $1" ;;
    esac
    shift
done

[ -f "$GAME/FlightSimulator2024.exe" ] || die "game not found: $GAME (set MSFS_GAME_DIR)"
[ -d "$SYS32" ] || die "Wine prefix not found: $PREFIX (set MSFS_PREFIX)"
exe=FlightSim; exe="${exe}ulator2024"
if pgrep -f "$exe\.exe" >/dev/null; then die "close the simulator first"; fi

wine_bin() {
    for d in "$FD"/runtimes/msfs2024/local/fenix-patch-*/runner/files/bin "$FD"/runtimes/msfs2024/runner/files/bin; do
        [ -x "$d/wine" ] && echo "$d"
    done | sort | tail -1
}

if [ $uninstall = 1 ]; then
    last="$(ls -d "$STATE"/backup-* 2>/dev/null | sort | tail -1)"
    [ -n "$last" ] || die "no backup in $STATE"
    say "restore $last"
    chmod u+w "$GAME/OptiScaler.ini" 2>/dev/null || true
    if [ -f "$last/added-game-files.txt" ]; then
        (cd "$GAME" && xargs -r -d '\n' rm -f < "$last/added-game-files.txt")
    fi
    (cd "$last/game" && cp -a . "$GAME/")
    (cd "$last/system32" && cp -a . "$SYS32/")
    [ -f "$last/added-system32-files.txt" ] && (cd "$SYS32" && xargs -r -d '\n' rm -f < "$last/added-system32-files.txt")
    echo "done (registry overrides are left in place)"
    exit 0
fi

# --- inputs -------------------------------------------------------------------------------
[ -n "$dlssu" ] || die "pass --dlss-unlocked <dlss-unlocked-standalone-NR-*.zip> (see README)"
[ -f "$dlssu" ] || die "not found: $dlssu"
if [ -z "$nvcuda" ]; then
    nvcuda="$(ls /usr/share/steam/compatibilitytools.d/*/files/lib/wine/nvidia-libs/nvcuda/x86_64-windows/nvcuda.dll.so \
        "$HOME"/.steam/root/compatibilitytools.d/*/files/lib/wine/nvidia-libs/nvcuda/x86_64-windows/nvcuda.dll.so \
        "$HOME"/.local/share/Steam/compatibilitytools.d/*/files/lib/wine/nvidia-libs/nvcuda/x86_64-windows/nvcuda.dll.so \
        2>/dev/null | head -1 || true)"
fi
[ -n "$nvcuda" ] && [ -f "$nvcuda" ] || die "nvcuda bridge not found; install Proton-CachyOS or pass --nvcuda (see README)"
NVNGX=/usr/lib/nvidia/wine/nvngx.dll
[ -f "$NVNGX" ] || NVNGX=/usr/lib64/nvidia/wine/nvngx.dll
[ -f "$NVNGX" ] || die "NVIDIA driver's wine/nvngx.dll not found (nvidia-utils)"
DXVK_NVAPI="$FD/runtimes/msfs2024/runner/files/lib/wine/nvapi/x86_64-windows/nvapi64.dll"
[ -f "$DXVK_NVAPI" ] || die "dxvk-nvapi not found at $DXVK_NVAPI"
WB="$(wine_bin)"; [ -n "$WB" ] || die "Flightdeck Wine runner not found"
command -v nvidia-smi >/dev/null || die "nvidia-smi not found"
gpu_name="$(nvidia-smi --query-gpu=name --format=csv,noheader | head -1)"
gpu_pci="$(nvidia-smi --query-gpu=pci.device_id --format=csv,noheader | head -1)"   # 0xDDDD10DE
gpu_device="0x$(printf '%s' "$gpu_pci" | cut -c3-6 | tr 'A-F' 'a-f')"
[ "${gpu_pci: -4}" = "10DE" ] || die "unexpected PCI id from nvidia-smi: $gpu_pci"

# --- shim -------------------------------------------------------------------------------
if [ ! -f "$HERE/build/nvapi64.dll" ]; then
    command -v x86_64-w64-mingw32-gcc >/dev/null || die "install mingw-w64 (x86_64-w64-mingw32-gcc) or put a built nvapi64.dll in build/"
    say "build shim"; bash "$HERE/build.sh" >/dev/null
fi
if [ $glass = 1 ] && [ ! -f "$HERE/build/glass-fix/winmm.dll" ]; then
    say "build glass cockpit fix (downloads the upstream source)"; bash "$HERE/glass-fix/build.sh" >/dev/null
fi

# --- DLSS Unlocked package ---------------------------------------------------------------
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
say "unpack $(basename "$dlssu")"
unzip -q "$dlssu" -d "$tmp/pkg"
pkg="$tmp/pkg"; [ -f "$pkg/dxgi.dll" ] || pkg="$(dirname "$(find "$tmp/pkg" -maxdepth 2 -name dxgi.dll | head -1)")"
for f in dxgi.dll nvngx_dlssnr.dll nvngx.dll_dlssnr.dll OptiScaler/dlssg_sm86/dlssg_sm86.dll; do
    [ -f "$pkg/$f" ] || die "DLSS Unlocked package incomplete: $f missing"
done

# staging tree with every file that goes into the game folder
stage="$tmp/game"; mkdir -p "$stage"
cp "$pkg/dxgi.dll" "$stage/version.dll"
cp "$pkg/nvngx_dlssnr.dll" "$pkg/nvngx.dll_dlssnr.dll" "$stage/"
cp -a "$pkg/OptiScaler" "$stage/OptiScaler"
[ -d "$pkg/Licenses" ] && cp -a "$pkg/Licenses" "$stage/Licenses"
cp "$NVNGX" "$stage/nvngx.dll"
cp "$HERE/config/dxvk.conf" "$stage/dxvk.conf"
[ $glass = 1 ] && cp "$HERE/build/glass-fix/winmm.dll" "$stage/winmm.dll"
sed -e "s#@DEVICE_ID@#$gpu_device#" -e "s#@GPU_NAME@#$gpu_name#" "$HERE/config/OptiScaler.ini" > "$stage/OptiScaler.ini"

# --- backup ------------------------------------------------------------------------------
bk="$STATE/backup-$(date +%Y%m%d-%H%M%S)"
say "back up replaced files to $bk"
mkdir -p "$bk/game" "$bk/system32"
: > "$bk/added-game-files.txt"; : > "$bk/added-system32-files.txt"
(cd "$stage" && find . -type f | sed 's|^\./||') | while read -r f; do
    if [ -e "$GAME/$f" ]; then
        mkdir -p "$bk/game/$(dirname "$f")"; cp -p "$GAME/$f" "$bk/game/$f"
    else
        echo "$f" >> "$bk/added-game-files.txt"
    fi
done
for f in nvapi64.dll nvapi64_dxvk.dll nvcuda.dll; do
    if [ -e "$SYS32/$f" ]; then cp -p "$SYS32/$f" "$bk/system32/$f"; else echo "$f" >> "$bk/added-system32-files.txt"; fi
done

# --- install -----------------------------------------------------------------------------
say "game folder: $GAME"
chmod u+w "$GAME/OptiScaler.ini" 2>/dev/null || true
(cd "$stage" && cp -a . "$GAME/")
chmod 444 "$GAME/OptiScaler.ini"   # OptiScaler's menu would otherwise rewrite it

say "prefix: $SYS32"
cp "$HERE/build/nvapi64.dll" "$SYS32/nvapi64.dll"
cp "$DXVK_NVAPI" "$SYS32/nvapi64_dxvk.dll"
cp "$nvcuda" "$SYS32/nvcuda.dll"

say "registry"
WINEPREFIX="$PREFIX" WINESERVER="$WB/wineserver" WINEDEBUG=-all "$WB/wine" regedit /S \
    "Z:$(printf '%s' "$HERE/config/wine.reg" | tr / '\\')"
WINEPREFIX="$PREFIX" WINESERVER="$WB/wineserver" "$WB/wineserver" -w

if [ -f "$USERCFG" ]; then
    sed -i 's/^\(\s*FrameGeneration\) DLSSG$/\1 NONE/' "$USERCFG"
fi

say "done: GPU '$gpu_name' ($gpu_device). Start the sim, set Anti-Aliasing to DLSS."
