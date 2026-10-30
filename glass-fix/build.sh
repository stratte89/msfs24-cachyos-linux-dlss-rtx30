#!/usr/bin/env bash
# Builds the Glass Cockpit DLSS Fix (IFreemz, GPL-3.0) for Wine with mingw-w64:
#   1. clones the upstream source at the pinned commit and MinHook at its pinned commit,
#   2. applies wine.patch,
#   3. takes the compiled shaders from the official 1.0.4 release DLL (checksum-verified),
#   4. compiles and links build/glass-fix/winmm.dll.
# Needs: git, curl, unzip, python3, mingw-w64 (x86_64-w64-mingw32-g++, windres, as).
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$HERE/../build/glass-fix"
UPSTREAM=https://github.com/IFreemz/msfs2024-glass-cockpit-dlss-fix
UPSTREAM_COMMIT=de97470989c5a322d4ed4192f69cc1948c228504
MINHOOK=https://github.com/TsudaKageyu/minhook
MINHOOK_COMMIT=8af6b4acae5a9388fd742b56fa79ece89d96f823
RELEASE_ZIP=$UPSTREAM/releases/download/v1.0.4/glass-cockpit-dlss-fix-standalone.zip
RELEASE_SHA256=344b464eb4408ace3d6418d6b9c01402d9e41e311823a6702590f8141907d980

for tool in git curl unzip python3 x86_64-w64-mingw32-g++ x86_64-w64-mingw32-gcc x86_64-w64-mingw32-windres x86_64-w64-mingw32-as; do
    command -v "$tool" >/dev/null || { echo "error: $tool not found" >&2; exit 1; }
done

rm -rf "$OUT"; mkdir -p "$OUT/obj" "$OUT/caseinc"
cd "$OUT"

git clone -q "$UPSTREAM" upstream
git -C upstream checkout -q "$UPSTREAM_COMMIT"
git clone -q "$MINHOOK" minhook
git -C minhook checkout -q "$MINHOOK_COMMIT"
git -C upstream apply "$HERE/wine.patch"
cp "$HERE/proxy_exports.S" upstream/src/

curl -sSfL -o release.zip "$RELEASE_ZIP"
echo "$RELEASE_SHA256  release.zip" | sha256sum -c --quiet
unzip -q -o release.zip dxgi.dll -d release
python3 "$HERE/extract_shaders.py" release/dxgi.dll obj

# The sources include <Windows.h>; MinGW ships windows.h.
ln -sf /usr/x86_64-w64-mingw32/include/windows.h caseinc/Windows.h
S=upstream/src
CXX=(x86_64-w64-mingw32-g++ -std=c++20 -O2 -w -DUNICODE -D_UNICODE -Icaseinc -Iobj -Iminhook/include -I"$S")
for f in buffer hook trampoline; do x86_64-w64-mingw32-gcc -O2 -c minhook/src/$f.c -o obj/$f.o; done
x86_64-w64-mingw32-gcc -O2 -c minhook/src/hde/hde64.c -o obj/hde64.o
# Only the main file needs the newer command-list IIDs; vtable_slots.cpp sets CINTERFACE before its own includes.
"${CXX[@]}" -include caseinc/Windows.h -include "$HERE/mingw_compat.h" -c "$S/glass_cockpit_dlss_fix.cpp" -o obj/glass_cockpit_dlss_fix.o
for f in status_report vtable_slots dxgi_proxy proxy_exports settings_window; do
    "${CXX[@]}" -c "$S/$f.cpp" -o obj/$f.o
done
x86_64-w64-mingw32-windres -I"$S" -Icaseinc -i "$S/version.rc" -o obj/version_res.o
x86_64-w64-mingw32-as -o obj/proxy_exports_asm.o "$S/proxy_exports.S"
O=(glass_cockpit_dlss_fix status_report vtable_slots buffer hook trampoline hde64 dxgi_proxy proxy_exports proxy_exports_asm settings_window version_res)
x86_64-w64-mingw32-g++ -shared -s -static -o winmm.dll $(printf "obj/%s.o " "${O[@]}") "$S/dxgi.def" \
    -ld3d12 -ldxguid -luuid -lversion -luser32 -lgdi32 -lshell32 -lole32 -lwindowscodecs -lgdiplus -lpsapi
sha256sum winmm.dll
