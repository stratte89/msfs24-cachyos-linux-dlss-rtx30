# How it works

## The problems under Wine

| # | Symptom | Cause |
|---|---|---|
| 1 | DLSS missing | dxvk-nvapi under this Wine build cannot match the Vulkan device to the DXGI adapter, so `NvAPI_Initialize` fails for the game and Streamline. |
| 2 | NGX core: "unsupported hw" | With a fake NvAPI instead, NVIDIA's NGX core (`_nvngx.dll`) fails `NvAPI_GetLogicalGPUFromPhysicalGPU`. |
| 3 | DLSS Frame Generation not offered | Streamline only offers DLSS-G on Ada or newer and needs hardware GPU scheduling, which Wine does not report. |
| 4 | `dlssg_sm86`: `Missing cuInit` | The runner's `nvcuda.dll` is a stub without exports. |
| 5 | DLSS-G `CreateFeature` fails with `0xBAD00002`, vkd3d "Failed to create cubin shader" | DLSS-G 310.9 builds all its kernels through NvAPI's CU interface, which dxvk-nvapi does not implement. |
| 6 | OptiScaler silently uses FSR 2.1.2 | OptiScaler's GPU check (`NvAPI_SYS_GetLogicalGPUs` → `GetLogicalGpuInfo` → `GetArchInfo`) fails, so it marks the GPU as not DLSS capable. |
| 7 | DLSS-G stripped from the game | OptiScaler's Internal frame-generation mode removes `sl.dlss_g` from the game's Streamline setup. |

## The shim (`src/nvshim.c`)

`nvapi_QueryInterface` returns a small thunk for every NvAPI function. On each call the thunk looks at the module that made the call (its return address) and picks an implementation:

| Caller | Gets |
|---|---|
| `_nvngx*`, `nvngx*` (NGX core and DLSS feature DLLs), `dlssg_sm86*`, `sm86_*` (frame-generation mod) | real dxvk-nvapi (`nvapi64_dxvk.dll`), initialised once; their `Initialize`/`Unload` are no-ops |
| OptiScaler (`version.dll`) passing on a call from an NGX module (found further up the stack) | real dxvk-nvapi |
| OptiScaler, GPU-identification IDs (`SYS_GetLogicalGPUs`, `GPU_GetLogicalGpuInfo`, `GPU_GetArchInfo`, `GPU_GetConnectedDisplayIds`) | real dxvk-nvapi (fixes 6) |
| everyone else, for the 33 IDs in `legacy_table` | fixed answers: one GPU, architecture Ada `0x190`, driver 615.78, 10 GB, PCI IDs and name from the first NVIDIA DXGI adapter, DRS calls succeed with "setting not found" (fixes 1, 2, 3) |
| everyone else, other IDs | real dxvk-nvapi |

### CU interface

The CU functions are answered only when `nvngx_dlssg.dll`, `dlssg_sm86.dll` or `sm86_backend.dll` is on the call stack. DLSS Super Resolution also asks for them, but works only on its older path without them.

| NvAPI function | Implementation |
|---|---|
| `CreateCuModule` | keeps a copy of the image (cubin / PTX / fatbin) |
| `CreateCuFunction` | keeps the module and the kernel name |
| `LaunchCuKernelChain`, `LaunchCuKernelChainEx` | per (block size, shared memory), creates a dxvk-nvapi cubin shader on first use (`CreateCubinComputeShaderEx`), then `LaunchCubinShader`. The CU interface passes the block size per launch; a cubin shader fixes it at creation. |
| `DestroyCuFunction`, `DestroyCuModule` | free the cached shaders (`DestroyCubinComputeShader`) |
| `IsFatbinPTXSupported` | false |

### Startup reset

When loaded into `FlightSimulator2024.exe`, the shim changes `FrameGeneration DLSSG` to `NONE` in `UserCfg.opt` once per process. Starting the sim with DLSS-G on has caused GPU MMU faults (Xid 31) on this setup.

### Log

`%TEMP%\nvshim5.log`: one line per (function, caller) routed to dxvk-nvapi, CU-layer decisions, the detected adapter.

## The rest

| Piece | Fixes |
|---|---|
| `nvcuda.dll` from nvidia-libs (Proton-CachyOS) | 4 |
| `OptiScaler.ini`: `SpoofHAGS = true` | 3 |
| `OptiScaler.ini`: `[FrameGen] External = true`, `AmpereMfgMode = External` | 7; the game's menu chooses the multiplier |
| `OptiScaler.ini`: `OverlayMenu = false` | OptiScaler's overlay causes `VK_ERROR_DEVICE_LOST` under Proton |
| `dxvk.conf`: `dxgi.hideNvidiaGpu = False` | dxvk-nvapi needs the real NVIDIA adapter |
| `wine.reg`: `version`, `nvapi64` = native,builtin | Wine loads OptiScaler and the shim instead of its builtins |

## Video memory: `VKD3D_CONFIG=no_upload_hvv`

With Resizable BAR on (check: `nvidia-smi -q -d MEMORY`, BAR1 total = 16 GB or more), vkd3d-proton places D3D12 UPLOAD heaps in host-visible VRAM. MSFS streams constantly, so this takes video memory a 10 GB card needs elsewhere. `no_upload_hvv` keeps upload heaps in system RAM, as on a system without Resizable BAR; uploads become slightly slower. `config/wine.reg` sets it in the Wine user environment (`HKCU\Environment`), which Wine applies to every Windows process in the prefix, so no launcher change is needed.

## Glass cockpit screens

DLSS rebuilds each frame from the history of earlier frames. Cockpit screens do not move, but their content does, so old digits blend into new ones. The Glass Cockpit DLSS Fix draws the sim's own screen image over the upscaled frame after DLSS. Under Wine three assumptions of the official build break (root signature identity, NVIDIA descriptor bytes, MSVC vtable layout); [glass-fix/README.md](../glass-fix/README.md) lists them with the changes.
