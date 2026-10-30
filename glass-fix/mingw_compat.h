// MinGW's d3d12.h ends at ID3D12GraphicsCommandList7. The fix only asks for the newer versions by IID (QueryInterface)
// to find their vtables; it calls nothing beyond version 7, so empty declarations with the right IIDs are enough.
#pragma once
#include <d3d12.h>
struct ID3D12GraphicsCommandList8 : ID3D12GraphicsCommandList7 {};
struct ID3D12GraphicsCommandList9 : ID3D12GraphicsCommandList8 {};
struct ID3D12GraphicsCommandList10 : ID3D12GraphicsCommandList9 {};
__CRT_UUID_DECL(ID3D12GraphicsCommandList8, 0xee936ef9, 0x599d, 0x4d28, 0x93, 0x8e, 0x23, 0xc4, 0xad, 0x05, 0xce, 0x51)
__CRT_UUID_DECL(ID3D12GraphicsCommandList9, 0x34ed2808, 0xffe6, 0x4c2b, 0xb1, 0x1a, 0xca, 0xbd, 0x2b, 0x0c, 0x59, 0xe1)
__CRT_UUID_DECL(ID3D12GraphicsCommandList10, 0x7013c015, 0xd161, 0x4b63, 0xa0, 0x8c, 0x23, 0x85, 0x52, 0xdd, 0x8a, 0xcc)
