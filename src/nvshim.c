// NvAPI router. Every entry point is a small thunk that looks at the module
// making the call (or, for calls passed on by OptiScaler, the modules further
// up the stack): NVIDIA's NGX core and its feature DLLs (_nvngx.dll,
// nvngx*.dll) and the SM86 frame-generation mod (dlssg_sm86.dll,
// sm86_backend.dll) get the real dxvk-nvapi (nvapi64_dxvk.dll, initialised on first
// use); everyone else gets the fixed answers below (the "legacy" table), which
// the game, Streamline and OptiScaler start up correctly with. IDs without a
// fixed answer go to dxvk-nvapi for every caller.
#include <windows.h>
#include <dxgi.h>
#include <stdio.h>
#include <stdarg.h>
#include <ctype.h>
#include <wchar.h>
#include <stdlib.h>

typedef void *(__cdecl *QueryInterface_t)(unsigned int);
typedef int(__cdecl *Initialize_t)(void);

#define ID_INITIALIZE 0x0150E828
#define ID_UNLOAD 0xD22BDD7E
#define MAX_SLOTS 512

struct slot {
    unsigned int id;
    void *legacy;
    void *real;
};

static struct slot slots[MAX_SLOTS];
static volatile LONG slot_count;
static unsigned char *thunks;
static QueryInterface_t real_qi;
static Initialize_t real_initialize;
static volatile LONG real_initialized;
static CRITICAL_SECTION lock;

static void log_line(const char *fmt, ...) {
    static unsigned int lines;
    if (lines++ > 4000)
        return;
    char path[MAX_PATH];
    DWORD n = GetTempPathA(MAX_PATH, path);
    if (!n || n > MAX_PATH - 16)
        return;
    strcat(path, "nvshim5.log");
    FILE *f = fopen(path, "a");
    if (!f)
        return;
    va_list args;
    va_start(args, fmt);
    vfprintf(f, fmt, args);
    va_end(args);
    fclose(f);
}

static HMODULE module_of(void *address) {
    HMODULE module = NULL;
    GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                       address, &module);
    return module;
}

static void module_basename(HMODULE module, char *out, size_t size);

static const char *module_name_of(void *address) {
    static __thread char name[MAX_PATH];
    HMODULE module = NULL;
    GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                       address, &module);
    module_basename(module, name, sizeof(name));
    return name;
}

static void module_basename(HMODULE module, char *out, size_t size) {
    char name[MAX_PATH];
    if (!module || !GetModuleFileNameA(module, name, MAX_PATH)) {
        snprintf(out, size, "?");
        return;
    }
    const char *base = strrchr(name, '\\');
    snprintf(out, size, "%s", base ? base + 1 : name);
    for (char *c = out; *c; c++)
        *c = (char)tolower((unsigned char)*c);
}

// Caches the verdict for the last few calling modules.
static BOOL is_ngx_module(HMODULE module) {
    static __thread HMODULE seen[8];
    static __thread BOOL verdict[8];
    for (int i = 0; i < 8; i++)
        if (seen[i] == module)
            return verdict[i];
    char name[MAX_PATH];
    module_basename(module, name, sizeof(name));
    BOOL ngx = !strncmp(name, "_nvngx", 6) || !strncmp(name, "nvngx", 5) || !strncmp(name, "dlssg_sm86", 10) ||
               !strncmp(name, "sm86_", 5);
    static __thread int next;
    seen[next] = module;
    verdict[next] = ngx;
    next = (next + 1) % 8;
    return ngx;
}

static void ensure_real_initialized(void) {
    if (real_initialized)
        return;
    EnterCriticalSection(&lock);
    if (!real_initialized) {
        int status = real_initialize ? real_initialize() : -1;
        log_line("real NvAPI_Initialize -> %d\n", status);
        real_initialized = 1;
    }
    LeaveCriticalSection(&lock);
}

// NvAPI's CU interface (NvAPI_D3D12_CreateCuModule / CreateCuFunction /
// LaunchCuKernelChain), which the DLSS-G 310.9 runtime builds all of its
// kernels with. dxvk-nvapi does not implement it, so it is layered over the
// cubin interface dxvk-nvapi does have: a module keeps its image, a function
// its name, and each (block size, shared memory) a function is launched with
// gets its own cubin shader, created on first launch, because the CU interface
// passes the block size per launch while a cubin shader fixes it at creation.
#define ID_CREATE_CU_MODULE 0xAD1A677D
#define ID_CREATE_CU_FUNCTION 0xE2436E22
#define ID_LAUNCH_CU_KERNEL_CHAIN 0x24973538
#define ID_LAUNCH_CU_KERNEL_CHAIN_EX 0x846A9BF0
#define ID_DESTROY_CU_MODULE 0x41C65285
#define ID_DESTROY_CU_FUNCTION 0xDF295EA6
#define ID_IS_FATBIN_PTX_SUPPORTED 0x70C07832
#define ID_CREATE_CUBIN_EX 0x3151211B
#define ID_LAUNCH_CUBIN 0x5C52BB86
#define ID_DESTROY_CUBIN 0x7FB785BA
#define NVAPI_OK 0
#define NVAPI_INVALID_POINTER (-14)
#define NVAPI_NOT_SUPPORTED (-104)
#define NVAPI_OUT_OF_MEMORY (-130)

typedef int(__cdecl *CreateCubinEx_t)(void *device, const void *cubin, unsigned size, unsigned bx, unsigned by,
                                      unsigned bz, unsigned shared, const char *name, void **shader);
typedef int(__cdecl *LaunchCubin_t)(void *list, void *shader, unsigned gx, unsigned gy, unsigned gz,
                                    const void *params, unsigned size);
typedef int(__cdecl *DestroyCubin_t)(void *device, void *shader);

typedef struct {
    unsigned x, y, z;
} dim3;

typedef struct {
    void *function;
    dim3 grid, block;
    unsigned shared;
    const void *params;
    unsigned params_size;
} cu_launch;

typedef struct {
    void *function;
    dim3 grid, block;
    unsigned shared;
    const void *params;
    unsigned params_size;
    void **kernel_params;
} cu_launch_ex;

struct cu_module {
    void *device;
    void *image;
    unsigned size;
};

struct cu_shader {
    dim3 block;
    unsigned shared;
    void *shader;
    struct cu_shader *next;
};

struct cu_function {
    struct cu_module *module;
    char *name;
    struct cu_shader *shaders;
};

static CreateCubinEx_t real_create_cubin;
static LaunchCubin_t real_launch_cubin;
static DestroyCubin_t real_destroy_cubin;
static CRITICAL_SECTION cu_lock;


static BOOL cu_ready(void) {
    ensure_real_initialized();
    return real_create_cubin && real_launch_cubin;
}

static int __cdecl cu_create_module(void *device, const void *blob, unsigned size, struct cu_module **out) {
    if (!device || !blob || !size || !out)
        return NVAPI_INVALID_POINTER;
    if (!cu_ready())
        return NVAPI_NOT_SUPPORTED;
    struct cu_module *module = calloc(1, sizeof(*module));
    void *image = malloc(size);
    if (!module || !image) {
        free(module);
        free(image);
        return NVAPI_OUT_OF_MEMORY;
    }
    memcpy(image, blob, size);
    module->device = device;
    module->image = image;
    module->size = size;
    *out = module;
    return NVAPI_OK;
}

static int __cdecl cu_create_function(void *device, struct cu_module *module, const char *name,
                                      struct cu_function **out) {
    if (!device || !module || !name || !out)
        return NVAPI_INVALID_POINTER;
    struct cu_function *function = calloc(1, sizeof(*function));
    char *copy = _strdup(name);
    if (!function || !copy) {
        free(function);
        free(copy);
        return NVAPI_OUT_OF_MEMORY;
    }
    function->module = module;
    function->name = copy;
    *out = function;
    return NVAPI_OK;
}

static int cu_shader_for(struct cu_function *function, dim3 block, unsigned shared, void **out) {
    EnterCriticalSection(&cu_lock);
    struct cu_shader *s = function->shaders;
    while (s && (s->block.x != block.x || s->block.y != block.y || s->block.z != block.z || s->shared != shared))
        s = s->next;
    int status = NVAPI_OK;
    if (!s) {
        void *shader = NULL;
        status = real_create_cubin(function->module->device, function->module->image, function->module->size,
                                   block.x, block.y, block.z, shared, function->name, &shader);
        static volatile LONG logged;
        if (status != NVAPI_OK || InterlockedIncrement(&logged) <= 3)
            log_line("CU %s block %ux%ux%u shared %u -> cubin shader %d\n", function->name, block.x, block.y, block.z,
                     shared, status);
        if (status == NVAPI_OK && (s = calloc(1, sizeof(*s)))) {
            s->block = block;
            s->shared = shared;
            s->shader = shader;
            s->next = function->shaders;
            function->shaders = s;
        } else if (status == NVAPI_OK) {
            real_destroy_cubin(function->module->device, shader);
            status = NVAPI_OUT_OF_MEMORY;
        }
    }
    *out = s ? s->shader : NULL;
    LeaveCriticalSection(&cu_lock);
    return status;
}

static int cu_launch_one(void *list, struct cu_function *function, dim3 grid, dim3 block, unsigned shared,
                         const void *params, unsigned params_size) {
    if (!function)
        return NVAPI_INVALID_POINTER;
    void *shader;
    int status = cu_shader_for(function, block, shared, &shader);
    if (status != NVAPI_OK)
        return status;
    return real_launch_cubin(list, shader, grid.x, grid.y, grid.z, params, params_size);
}

static int __cdecl cu_launch_chain(void *list, const cu_launch *kernels, unsigned count) {
    if (!list || !kernels || !count)
        return NVAPI_INVALID_POINTER;
    if (!cu_ready())
        return NVAPI_NOT_SUPPORTED;
    for (unsigned i = 0; i < count; i++) {
        const cu_launch *k = &kernels[i];
        int status = cu_launch_one(list, k->function, k->grid, k->block, k->shared, k->params, k->params_size);
        if (status != NVAPI_OK)
            return status;
    }
    return NVAPI_OK;
}

static int __cdecl cu_launch_chain_ex(void *list, const cu_launch_ex *kernels, unsigned count) {
    if (!list || !kernels || !count)
        return NVAPI_INVALID_POINTER;
    if (!cu_ready())
        return NVAPI_NOT_SUPPORTED;
    for (unsigned i = 0; i < count; i++) {
        const cu_launch_ex *k = &kernels[i];
        // Only the packed parameter buffer maps onto a cubin launch.
        if (!k->params && k->kernel_params)
            return NVAPI_NOT_SUPPORTED;
        int status = cu_launch_one(list, k->function, k->grid, k->block, k->shared, k->params, k->params_size);
        if (status != NVAPI_OK)
            return status;
    }
    return NVAPI_OK;
}

static int __cdecl cu_destroy_function(void *device, struct cu_function *function) {
    if (!device || !function)
        return NVAPI_INVALID_POINTER;
    for (struct cu_shader *s = function->shaders, *next; s; s = next) {
        next = s->next;
        real_destroy_cubin(device, s->shader);
        free(s);
    }
    free(function->name);
    free(function);
    return NVAPI_OK;
}

static int __cdecl cu_destroy_module(void *device, struct cu_module *module) {
    if (!device || !module)
        return NVAPI_INVALID_POINTER;
    free(module->image);
    free(module);
    return NVAPI_OK;
}

// Fatbins may carry PTX, which a cubin shader cannot take.
static int __cdecl cu_is_fatbin_ptx_supported(void *device, BOOL *supported) {
    if (!device || !supported)
        return NVAPI_INVALID_POINTER;
    *(unsigned char *)supported = 0;
    return NVAPI_OK;
}

static void *cu_entry(unsigned int id) {
    switch (id) {
    case ID_CREATE_CU_MODULE:
        return cu_create_module;
    case ID_CREATE_CU_FUNCTION:
        return cu_create_function;
    case ID_LAUNCH_CU_KERNEL_CHAIN:
        return cu_launch_chain;
    case ID_LAUNCH_CU_KERNEL_CHAIN_EX:
        return cu_launch_chain_ex;
    case ID_DESTROY_CU_MODULE:
        return cu_destroy_module;
    case ID_DESTROY_CU_FUNCTION:
        return cu_destroy_function;
    case ID_IS_FATBIN_PTX_SUPPORTED:
        return cu_is_fatbin_ptx_supported;
    }
    return NULL;
}

static int ok_stub(void) { return 0; }

// OptiScaler (VERSION.dll) wraps some NvAPI functions, so an NGX module's call
// can arrive with OptiScaler as the immediate caller. For those calls, look for
// a return address inside a loaded NGX module further up the stack.
static const wchar_t *const ngx_names[] = {L"_nvngx.dll", L"nvngx_dlssg.dll", L"nvngx_dlss.dll",
                                           L"nvngx_dlssnr.dll", L"nvngx_dlssd.dll"};

static BOOL ngx_module_up_the_stack(void **slot) {
    struct {
        ULONG_PTR start, end;
    } ranges[sizeof(ngx_names) / sizeof(ngx_names[0])];
    int count = 0;
    for (size_t i = 0; i < sizeof(ngx_names) / sizeof(ngx_names[0]); i++) {
        HMODULE module = GetModuleHandleW(ngx_names[i]);
        if (!module)
            continue;
        IMAGE_DOS_HEADER *dos = (IMAGE_DOS_HEADER *)module;
        IMAGE_NT_HEADERS *nt = (IMAGE_NT_HEADERS *)((BYTE *)module + dos->e_lfanew);
        ranges[count].start = (ULONG_PTR)module;
        ranges[count].end = (ULONG_PTR)module + nt->OptionalHeader.SizeOfImage;
        count++;
    }
    ULONG_PTR top = (ULONG_PTR)((NT_TIB *)NtCurrentTeb())->StackBase;
    for (int depth = 1; depth <= 48 && (ULONG_PTR)&slot[depth + 1] <= top; depth++) {
        ULONG_PTR value = (ULONG_PTR)slot[depth];
        for (int i = 0; i < count; i++)
            if (value >= ranges[i].start && value < ranges[i].end)
                return TRUE;
    }
    return FALSE;
}

// Frame generation only: DLSS super resolution (nvngx_dlss.dll) also asks for the
// CU interface, but its kernels do not work through this layer and it runs fine
// on the cubin path it uses when the CU interface is missing.
static const wchar_t *const cu_users[] = {L"nvngx_dlssg.dll", L"dlssg_sm86.dll", L"sm86_backend.dll"};

static BOOL cu_user_up_the_stack(void **frame) {
    HMODULE modules[sizeof(cu_users) / sizeof(cu_users[0])];
    ULONG_PTR ends[sizeof(cu_users) / sizeof(cu_users[0])];
    int count = 0;
    for (size_t i = 0; i < sizeof(cu_users) / sizeof(cu_users[0]); i++) {
        HMODULE module = GetModuleHandleW(cu_users[i]);
        if (!module)
            continue;
        IMAGE_NT_HEADERS *nt = (IMAGE_NT_HEADERS *)((BYTE *)module + ((IMAGE_DOS_HEADER *)module)->e_lfanew);
        modules[count] = module;
        ends[count++] = (ULONG_PTR)module + nt->OptionalHeader.SizeOfImage;
    }
    ULONG_PTR top = (ULONG_PTR)((NT_TIB *)NtCurrentTeb())->StackBase;
    for (int depth = 0; depth < 256 && (ULONG_PTR)&frame[depth + 1] <= top; depth++) {
        ULONG_PTR value = (ULONG_PTR)frame[depth];
        for (int i = 0; i < count; i++)
            if (value >= (ULONG_PTR)modules[i] && value < ends[i])
                return TRUE;
    }
    return FALSE;
}

static BOOL is_optiscaler_module(HMODULE module) {
    char name[MAX_PATH];
    module_basename(module, name, sizeof(name));
    return !strcmp(name, "version.dll") && module != GetModuleHandleW(L"C:\\windows\\system32\\version.dll");
}

// OptiScaler's GPU identification (IdentifyGpu::queryNvapi) walks logical GPU ->
// physical GPU -> architecture. The legacy shim answers the first step with
// NVAPI_API_NOT_INITIALIZED, so OptiScaler marks the GPU as not DLSS capable and
// silently replaces every DLSS upscaler with FSR 2.1.2.
static const unsigned int optiscaler_gpu_ids[] = {
    0xCCFFFC10, // NvAPI_SYS_GetLogicalGPUs
    0x842B066E, // NvAPI_GPU_GetLogicalGpuInfo
    0xD8265D24, // NvAPI_GPU_GetArchInfo
    0x0078DBA2, // NvAPI_GPU_GetConnectedDisplayIds
};

static BOOL is_optiscaler_gpu_id(unsigned int id) {
    for (size_t i = 0; i < sizeof(optiscaler_gpu_ids) / sizeof(optiscaler_gpu_ids[0]); i++)
        if (optiscaler_gpu_ids[i] == id)
            return TRUE;
    return FALSE;
}

// Called by the thunks: picks the implementation for this caller.
void *__cdecl nvshim_route(void *return_address, unsigned int index, void **return_slot) {
    struct slot *s = &slots[index];
    HMODULE caller = module_of(return_address);
    BOOL ngx = is_ngx_module(caller);
    if (!ngx && s->real && is_optiscaler_module(caller) && ngx_module_up_the_stack(return_slot)) {
        ngx = TRUE;
        static volatile LONG logged_via[MAX_SLOTS];
        if (!InterlockedExchange(&logged_via[index], 1))
            log_line("route %08x -> real for NGX via OptiScaler\n", s->id);
    }
    if (!ngx && s->real && is_optiscaler_gpu_id(s->id) && is_optiscaler_module(caller))
        ngx = TRUE;
    if (s->real && ngx) {
        // The real NvAPI stays initialised for the rest of the process.
        if (s->id == ID_INITIALIZE || s->id == ID_UNLOAD) {
            ensure_real_initialized();
            return (void *)ok_stub;
        }
        ensure_real_initialized();
        // Log each (function, calling module) pair once.
        static volatile LONG64 logged[1024];
        LONG64 key = ((LONG64)(ULONG_PTR)caller << 12) ^ (s->id + 1);
        for (int i = (int)(key % 1024 + 1024) % 1024, n = 0; n < 1024; i = (i + 1) % 1024, n++) {
            LONG64 seen = InterlockedCompareExchange64(&logged[i], key, 0);
            if (seen == key)
                break;
            if (seen == 0) {
                char name[MAX_PATH];
                module_basename(caller, name, sizeof(name));
                log_line("route %08x -> real for %s\n", s->id, name);
                break;
            }
        }
        return s->real;
    }
    return s->legacy ? s->legacy : s->real;
}

// Thunk entry: r10 holds the slot index. Saves the integer argument registers,
// asks nvshim_route for the target and jumps to it with the arguments intact.
__asm__(".globl nvshim_common\n"
        "nvshim_common:\n"
        "  push %rcx\n"
        "  push %rdx\n"
        "  push %r8\n"
        "  push %r9\n"
        "  sub $40, %rsp\n"
        "  mov 72(%rsp), %rcx\n"
        "  mov %r10d, %edx\n"
        "  lea 72(%rsp), %r8\n"
        "  call nvshim_route\n"
        "  add $40, %rsp\n"
        "  pop %r9\n"
        "  pop %r8\n"
        "  pop %rdx\n"
        "  pop %rcx\n"
        "  jmp *%rax\n");
void nvshim_common(void);

#define THUNK_SIZE 32

static void *make_thunk(unsigned int index) {
    unsigned char *t = thunks + index * THUNK_SIZE;
    // mov r10d, imm32
    t[0] = 0x41;
    t[1] = 0xBA;
    memcpy(t + 2, &index, 4);
    // mov rax, imm64 ; jmp rax
    t[6] = 0x48;
    t[7] = 0xB8;
    void *target = (void *)nvshim_common;
    memcpy(t + 8, &target, 8);
    t[16] = 0xFF;
    t[17] = 0xE0;
    return t;
}

static QueryInterface_t load_qi(const wchar_t *file) {
    wchar_t path[MAX_PATH];
    UINT n = GetSystemDirectoryW(path, MAX_PATH);
    if (!n || n > MAX_PATH - 32)
        return NULL;
    wcscat(path, L"\\");
    wcscat(path, file);
    HMODULE module = LoadLibraryW(path);
    if (!module) {
        log_line("load %ls failed %lu\n", file, GetLastError());
        return NULL;
    }
    return (QueryInterface_t)GetProcAddress(module, "nvapi_QueryInterface");
}

// Fixed answers for callers that must not see dxvk-nvapi (it cannot match the
// Vulkan device to the DXGI adapter on this Wine, so NvAPI_Initialize fails for
// them). One GPU, handle 0x30803080 (logical 0x30803081, DRS session/profile
// 0x30803090), reported as Ada (arch 0x190) so Streamline offers DLSS-G, driver
// 615.78. PCI IDs and the name come from the first NVIDIA DXGI adapter.
#define LEGACY_GPU ((void *)(ULONG_PTR)0x30803080)
#define LEGACY_LOGICAL_GPU ((void *)(ULONG_PTR)0x30803081)
#define LEGACY_DRS ((void *)(ULONG_PTR)0x30803090)
#define NVAPI_ERROR_INVALID_ARGUMENT (-5)
#define NVAPI_EXECUTABLE_NOT_FOUND (-203)
#define NVAPI_SETTING_NOT_FOUND (-204)

static char adapter_name[64] = "NVIDIA GeForce RTX 3080 10GB (LHR)";
static unsigned int adapter_vendor = 0x10DE, adapter_device = 0x2216, adapter_subsys, adapter_rev = 0xA1;
static volatile LONG adapter_detected;

static void detect_adapter(void) {
    if (InterlockedExchange(&adapter_detected, 1))
        return;
    HMODULE dxgi = LoadLibraryA("dxgi.dll");
    typedef HRESULT(WINAPI * CreateFactory1_t)(REFIID, void **);
    CreateFactory1_t create = dxgi ? (CreateFactory1_t)GetProcAddress(dxgi, "CreateDXGIFactory1") : NULL;
    IDXGIFactory *factory = NULL;
    if (!create || FAILED(create(&IID_IDXGIFactory, (void **)&factory)) || !factory)
        return;
    for (UINT i = 0; i < 8; i++) {
        IDXGIAdapter *adapter = NULL;
        if (FAILED(factory->lpVtbl->EnumAdapters(factory, i, &adapter)))
            break;
        DXGI_ADAPTER_DESC desc = {0};
        HRESULT hr = adapter->lpVtbl->GetDesc(adapter, &desc);
        adapter->lpVtbl->Release(adapter);
        if (SUCCEEDED(hr) && desc.VendorId == 0x10DE) {
            adapter_vendor = 0x10DE;
            adapter_device = desc.DeviceId;
            adapter_subsys = desc.SubSysId;
            adapter_rev = desc.Revision;
            WideCharToMultiByte(CP_ACP, 0, desc.Description, -1, adapter_name, sizeof(adapter_name), NULL, NULL);
            log_line("legacy adapter %04x:%04x subsys %08x rev %02x %s\n", adapter_vendor, adapter_device,
                     adapter_subsys, adapter_rev, adapter_name);
            break;
        }
    }
    factory->lpVtbl->Release(factory);
}

// Versioned structs: clear the size in the low 16 bits of the version, keep the version.
static void *versioned_clear(void *s) {
    unsigned int version = *(unsigned int *)s;
    memset(s, 0, version & 0xFFFF);
    *(unsigned int *)s = version;
    return s;
}
#define AT(p, off, type) (*(type *)((char *)(p) + (off)))

static int __cdecl lg_ok(void) { return NVAPI_OK; }

static int __cdecl lg_initialize(void) {
    detect_adapter();
    return NVAPI_OK;
}

static int __cdecl lg_enum_gpus(void **handles, unsigned int *count) {
    detect_adapter();
    unsigned int i = 0;
    if (handles)
        while (i < 32 && handles[i])
            i++;
    if (handles)
        handles[i] = LEGACY_GPU;
    if (count)
        *count = i + 1;
    return NVAPI_OK;
}

static int __cdecl lg_enum_logical_gpus(void **handles, unsigned int *count) {
    if (handles)
        handles[0] = LEGACY_LOGICAL_GPU;
    if (count)
        *count = 1;
    return NVAPI_OK;
}

static int __cdecl lg_physical_from_logical(void *logical, void **handles, unsigned int *count) {
    if (handles)
        handles[0] = LEGACY_GPU;
    if (count)
        *count = 1;
    return NVAPI_OK;
}

static int __cdecl lg_full_name(void *gpu, char *name) {
    detect_adapter();
    if (name) {
        memset(name, 0, 64);
        strcpy(name, adapter_name);
    }
    return NVAPI_OK;
}

static int __cdecl lg_driver_version(unsigned int *version, char *branch) {
    if (version)
        *version = 61578;
    if (branch) {
        memset(branch, 0, 64);
        strcpy(branch, "r615_00");
    }
    return NVAPI_OK;
}

static int __cdecl lg_pci_ids(void *gpu, unsigned int *device, unsigned int *subsys, unsigned int *revision,
                              unsigned int *ext_device) {
    detect_adapter();
    if (device)
        *device = adapter_vendor << 16 | adapter_device;
    if (subsys)
        *subsys = adapter_subsys;
    if (revision)
        *revision = adapter_rev;
    if (ext_device)
        *ext_device = 0;
    return NVAPI_OK;
}

static int __cdecl lg_bus_id(void *gpu, unsigned int *value) {
    if (value)
        *value = 1;
    return NVAPI_OK;
}

static int __cdecl lg_bus_slot(void *gpu, unsigned int *value) {
    if (value)
        *value = 0;
    return NVAPI_OK;
}

static int __cdecl lg_bus_type(void *gpu, unsigned int *value) {
    if (value)
        *value = 3; // PCI Express
    return NVAPI_OK;
}

static int __cdecl lg_system_type(void *gpu, unsigned int *value) {
    if (value)
        *value = 2; // desktop
    return NVAPI_OK;
}

static int __cdecl lg_interface_version(char *text) {
    if (text) {
        memset(text, 0, 64);
        strcpy(text, "NVAPI Complete Version 1.10 (r615)");
    }
    return NVAPI_OK;
}

static int __cdecl lg_error_message(int status, char *text) {
    if (text) {
        memset(text, 0, 64);
        strcpy(text, status ? "NVAPI_ERROR" : "NVAPI_OK");
    }
    return NVAPI_OK;
}

static int __cdecl lg_chipset(void *info) {
    if (!info)
        return NVAPI_ERROR_INVALID_ARGUMENT;
    AT(info, 0x00, unsigned long long) = 0x10DE00040058ULL; // version 0x40058, vendor 0x10de
    memset((char *)info + 0x0F, 0, 0x49);
    memcpy((char *)info + 0x08, "NVIDIA", 7);
    memcpy((char *)info + 0x28, adapter_name, strnlen(adapter_name, 0x1F));
    AT(info, 0x50, unsigned long long) = (ULONG_PTR)LEGACY_GPU;
    return NVAPI_OK;
}

static int __cdecl lg_arch_info(void *gpu, void *info) {
    if (!info)
        return NVAPI_ERROR_INVALID_ARGUMENT;
    versioned_clear(info);
    AT(info, 0x04, unsigned int) = 0x190; // architecture: Ada
    AT(info, 0x08, unsigned int) = 2;     // implementation
    AT(info, 0x0C, unsigned int) = 0xA1;  // revision
    return NVAPI_OK;
}

static int __cdecl lg_memory_info(void *gpu, void *info) {
    if (!info)
        return NVAPI_ERROR_INVALID_ARGUMENT;
    versioned_clear(info);
    AT(info, 0x08, unsigned long long) = 0xA00000; // 10 GB in KB
    AT(info, 0x10, unsigned long long) = 0xA00000;
    AT(info, 0x18, unsigned long long) = 0;
    AT(info, 0x20, unsigned long long) = 0x800000;
    AT(info, 0x28, unsigned long long) = 0xA00000;
    return NVAPI_OK;
}

static int __cdecl lg_vbios(void *gpu, char *text) {
    if (text) {
        memset(text, 0, 64);
        strcpy(text, "94.02.7A.40.00");
    }
    return NVAPI_OK;
}

static int __cdecl lg_sli_state(void *device, void *state) {
    if (!state)
        return NVAPI_ERROR_INVALID_ARGUMENT;
    versioned_clear(state);
    AT(state, 0x04, unsigned int) = 1;
    AT(state, 0x08, unsigned int) = 1;
    AT(state, 0x18, unsigned int) = 1;
    return NVAPI_OK;
}

static int __cdecl lg_object_handle(void *device, void *resource, void *unused, void **handle) {
    if (handle)
        *handle = resource ? resource : LEGACY_GPU;
    return NVAPI_OK;
}

static int __cdecl lg_drs_create_session(void **session) {
    if (session)
        *session = LEGACY_DRS;
    return NVAPI_OK;
}

static int __cdecl lg_drs_global_profile(void *session, void **profile) {
    if (profile)
        *profile = LEGACY_DRS;
    return NVAPI_OK;
}

static int __cdecl lg_drs_get_setting(void) { return NVAPI_SETTING_NOT_FOUND; }

static int __cdecl lg_drs_find_application(void) { return NVAPI_EXECUTABLE_NOT_FOUND; }

static int __cdecl lg_drs_profile_info(void *session, void *profile, void *info) {
    if (!info)
        return NVAPI_ERROR_INVALID_ARGUMENT;
    versioned_clear(info);
    wcscpy((wchar_t *)((char *)info + 4), L"Base Profile");
    AT(info, 0x804, unsigned long long) = 0x100000001ULL; // isPredefined 1, gpuSupport 1
    return NVAPI_OK;
}

static const struct {
    unsigned int id;
    void *function;
} legacy_table[] = {
    {0x0150E828, lg_initialize},            // NvAPI_Initialize
    {0xD22BDD7E, lg_ok},                    // NvAPI_Unload
    {0xE5AC921F, lg_enum_gpus},             // NvAPI_EnumPhysicalGPUs
    {0xD9930B07, lg_enum_gpus},             // NvAPI_EnumTCCPhysicalGPUs
    {0x48B3EA59, lg_enum_logical_gpus},     // NvAPI_EnumLogicalGPUs
    {0xAEA3FA32, lg_physical_from_logical}, // NvAPI_GetPhysicalGPUsFromLogicalGPU
    {0xCEEE8E9F, lg_full_name},             // NvAPI_GPU_GetFullName
    {0x2926AAAD, lg_driver_version},        // NvAPI_SYS_GetDriverAndBranchVersion
    {0x2DDFB66E, lg_pci_ids},               // NvAPI_GPU_GetPCIIdentifiers
    {0x1BE0B8E5, lg_bus_id},                // NvAPI_GPU_GetBusId
    {0x2A0A350F, lg_bus_slot},              // NvAPI_GPU_GetBusSlotId
    {0x1BB18724, lg_bus_type},              // NvAPI_GPU_GetBusType
    {0xBAAABFCC, lg_system_type},           // NvAPI_GPU_GetSystemType
    {0x01053FA5, lg_interface_version},     // NvAPI_GetInterfaceVersionString
    {0x6C2D048C, lg_error_message},         // NvAPI_GetErrorMessage
    {0x53DABBCA, lg_chipset},               // NvAPI_SYS_GetChipSetInfo
    {0xD8265D24, lg_arch_info},             // NvAPI_GPU_GetArchInfo
    {0x07F9B368, lg_memory_info},           // NvAPI_GPU_GetMemoryInfo
    {0xA561FD7D, lg_vbios},                 // NvAPI_GPU_GetVbiosVersionString
    {0x4B708B54, lg_sli_state},             // NvAPI_D3D_GetCurrentSLIState
    {0xFCEAC864, lg_object_handle},         // NvAPI_D3D_GetObjectHandleForResource
    {0x986D3CE3, lg_ok},                    // NvAPI_D3D_SetSLIState
    {0x0694D52E, lg_drs_create_session},    // NvAPI_DRS_CreateSession
    {0xDAD9CFF8, lg_ok},                    // NvAPI_DRS_DestroySession
    {0x375DBD6B, lg_ok},                    // NvAPI_DRS_LoadSettings
    {0xFCBC7E14, lg_ok},                    // NvAPI_DRS_SaveSettings
    {0x617BFF9F, lg_drs_global_profile},    // NvAPI_DRS_GetCurrentGlobalProfile
    {0x73BF8338, lg_drs_get_setting},       // NvAPI_DRS_GetSetting
    {0x577DD202, lg_ok},                    // NvAPI_DRS_SetSetting
    {0x61CD6FD6, lg_drs_profile_info},      // NvAPI_DRS_GetProfileInfo
    {0xCC176068, lg_ok},                    // NvAPI_DRS_CreateProfile
    {0xEEE566B2, lg_drs_find_application},  // NvAPI_DRS_FindApplicationByName
    {0x4347A9DE, lg_ok},                    // NvAPI_DRS_CreateApplication
};

static void *legacy_entry(unsigned int id) {
    for (size_t i = 0; i < sizeof(legacy_table) / sizeof(legacy_table[0]); i++)
        if (legacy_table[i].id == id)
            return legacy_table[i].function;
    return NULL;
}

// Starting with DLSS frame generation already on crashes the sim (DLSS-G is
// created before the game is ready), so it starts with it off: the sim's saved
// "FrameGeneration DLSSG" is set to NONE before the game reads its settings.
// The player switches it on again in the graphics menu once loaded.
static void reset_saved_frame_generation(void) {
    wchar_t exe[MAX_PATH];
    if (!GetModuleFileNameW(NULL, exe, MAX_PATH))
        return;
    const wchar_t *base = wcsrchr(exe, L'\\');
    if (_wcsicmp(base ? base + 1 : exe, L"FlightSimulator2024.exe"))
        return;
    wchar_t path[MAX_PATH], temp[MAX_PATH];
    DWORD n = GetEnvironmentVariableW(L"APPDATA", path, MAX_PATH);
    if (!n || n > MAX_PATH - 64)
        return;
    wcscat(path, L"\\Microsoft Flight Simulator 2024\\UserCfg.opt");
    HANDLE file = CreateFileW(path, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);
    if (file == INVALID_HANDLE_VALUE)
        return;
    static char data[1 << 20];
    DWORD size = 0;
    BOOL ok = ReadFile(file, data, sizeof(data) - 1, &size, NULL);
    CloseHandle(file);
    if (!ok || size == sizeof(data) - 1)
        return;
    data[size] = 0;
    static const char key[] = "\tFrameGeneration DLSSG";
    char *line = strstr(data, key);
    if (!line || (line[sizeof(key) - 1] != '\r' && line[sizeof(key) - 1] != '\n'))
        return;
    char *value = line + sizeof(key) - 1 - 5;
    char *rest = value + 5;
    swprintf(temp, MAX_PATH, L"%ls.nvshim", path);
    file = CreateFileW(temp, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, 0, NULL);
    if (file == INVALID_HANDLE_VALUE)
        return;
    DWORD written;
    ok = WriteFile(file, data, (DWORD)(value - data), &written, NULL) && WriteFile(file, "NONE", 4, &written, NULL) &&
         WriteFile(file, rest, (DWORD)(data + size - rest), &written, NULL);
    CloseHandle(file);
    if (ok && MoveFileExW(temp, path, MOVEFILE_REPLACE_EXISTING))
        log_line("UserCfg.opt: FrameGeneration DLSSG -> NONE for startup\n");
    else
        DeleteFileW(temp);
}

BOOL WINAPI DllMain(HINSTANCE instance, DWORD reason, LPVOID reserved) {
    if (reason == DLL_PROCESS_ATTACH) {
        InitializeCriticalSection(&lock);
        InitializeCriticalSection(&cu_lock);
        thunks = VirtualAlloc(NULL, MAX_SLOTS * THUNK_SIZE, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
        // OptiScaler unloads and reloads nvapi64.dll whenever the game applies
        // settings, so the "once per sim start" marker lives in the process
        // environment, not in this module.
        if (!GetEnvironmentVariableA("NVSHIM_STARTUP_DONE", NULL, 0)) {
            SetEnvironmentVariableA("NVSHIM_STARTUP_DONE", "1");
            reset_saved_frame_generation();
        }
    }
    return TRUE;
}

__declspec(dllexport) void *__cdecl nvapi_QueryInterface(unsigned int id) {
    if (!thunks)
        return NULL;
    EnterCriticalSection(&lock);
    if (!real_qi) {
        real_qi = load_qi(L"nvapi64_dxvk.dll");
        if (real_qi) {
            real_initialize = (Initialize_t)real_qi(ID_INITIALIZE);
            real_create_cubin = (CreateCubinEx_t)real_qi(ID_CREATE_CUBIN_EX);
            real_launch_cubin = (LaunchCubin_t)real_qi(ID_LAUNCH_CUBIN);
            real_destroy_cubin = (DestroyCubin_t)real_qi(ID_DESTROY_CUBIN);
        }
    }
    void *result = cu_entry(id);
    if (result) {
        LeaveCriticalSection(&lock);
        BOOL serve = cu_user_up_the_stack((void **)__builtin_frame_address(0));
        log_line("QI %08x -> %s for %s\n", id, serve ? "CU layer" : "not available",
                 module_name_of(__builtin_return_address(0)));
        return serve ? result : NULL;
    }
    LONG i;
    for (i = 0; i < slot_count; i++)
        if (slots[i].id == id)
            break;
    if (i == slot_count && i < MAX_SLOTS) {
        slots[i].id = id;
        slots[i].legacy = legacy_entry(id);
        slots[i].real = real_qi ? real_qi(id) : NULL;
        make_thunk(i);
        FlushInstructionCache(GetCurrentProcess(), thunks, MAX_SLOTS * THUNK_SIZE);
        slot_count = i + 1;
    }
    if (i < MAX_SLOTS && (slots[i].legacy || slots[i].real))
        result = thunks + i * THUNK_SIZE;
    LeaveCriticalSection(&lock);
    return result;
}
