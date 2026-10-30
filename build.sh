#!/usr/bin/env bash
# Builds build/nvapi64.dll from src/nvshim.c. Needs mingw-w64 (x86_64-w64-mingw32-gcc).
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build
x86_64-w64-mingw32-gcc -O2 -Wall -shared -s -o build/nvapi64.dll src/nvshim.c -Wl,--kill-at -ldxguid
sha256sum build/nvapi64.dll
