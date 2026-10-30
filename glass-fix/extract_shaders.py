#!/usr/bin/env python3
"""Writes the glass fix's 200 compiled shaders as C headers (overlay_shaders.h + one header per shader),
taken byte-for-byte from the official release DLL.

The upstream build compiles them with Microsoft's dxc; the Linux dxc 1.10.2605 from the Arch/CachyOS
repositories aborts on these shaders. The shader sources are identical between the release (1.0.4) and
the pinned commit, so the release DLL holds exactly the shaders this build needs.

    extract_shaders.py <official dxgi.dll> <output dir>
"""
import re
import struct
import sys

VARIANTS = ['map_ps', 'map_ps_b', 'map_ps_vr', 'map_ps_vr_b', 'map_ps_t0', 'map_ps_vr_t0']  # build.ps1 loop order
COMPUTE = ['zero', 'fit', 'solve', 'composite', 'clear', 'glass_filter']


def main(dll, out):
    data = open(dll, 'rb').read()
    blobs = []
    for m in re.finditer(b'DXBC', data):
        o = m.start()
        size, parts = struct.unpack_from('<II', data, o + 24)
        if 32 < size < 2_000_000 and 0 < parts < 32 and o + size <= len(data):
            blobs.append(data[o:o + size])
    names = [f'{v}_{slot}' for slot in range(32) for v in VARIANTS]
    names += ['map_colour_ps', 'map_colour_ps_t0'] + [f'cs_{p}' for p in COMPUTE]
    if len(blobs) != len(names):
        sys.exit(f'expected {len(names)} shaders, found {len(blobs)}')
    # Order checks: compute passes carry their entry point name, VR variants an SV_IsFrontFace input.
    for name, blob in zip(names[-6:], blobs[-6:]):
        if name[3:].encode() + b'\0' not in blob:
            sys.exit(f'shader order mismatch at {name}')
    for i in range(192):
        if (b'SV_IsFrontFace' in blobs[i]) != ('_vr' in names[i]):
            sys.exit(f'shader order mismatch at {names[i]}')
    for name, blob in zip(names, blobs):
        with open(f'{out}/{name}.h', 'w') as f:
            f.write(f'const unsigned char {name}[] = {{\n')
            for i in range(0, len(blob), 16):
                f.write('  ' + ', '.join(f'0x{b:02x}' for b in blob[i:i + 16]) + ',\n')
            f.write('};\n')
    with open(f'{out}/overlay_shaders.h', 'w') as f:
        f.write('#pragma once\n' + ''.join(f'#include "{n}.h"\n' for n in names))
    print(f'{len(names)} shaders written')


if __name__ == '__main__':
    main(*sys.argv[1:3])
