# GNU as port of proxy_exports.asm (generated): same stubs, Intel syntax.
.intel_syntax noprefix
.text
.globl proxy_resolve_common
proxy_resolve_common:
    push rcx
    push rdx
    push r8
    push r9
    sub rsp, 0x68
    movdqu xmmword ptr [rsp + 0x20], xmm0
    movdqu xmmword ptr [rsp + 0x30], xmm1
    movdqu xmmword ptr [rsp + 0x40], xmm2
    movdqu xmmword ptr [rsp + 0x50], xmm3
    mov ecx, r11d
    call glass_proxy_resolve
    movdqu xmm0, xmmword ptr [rsp + 0x20]
    movdqu xmm1, xmmword ptr [rsp + 0x30]
    movdqu xmm2, xmmword ptr [rsp + 0x40]
    movdqu xmm3, xmmword ptr [rsp + 0x50]
    add rsp, 0x68
    pop r9
    pop r8
    pop rdx
    pop rcx
    jmp rax
.globl proxy_version_GetFileVersionInfoA
proxy_version_GetFileVersionInfoA:
    mov rax, qword ptr [rip + glass_proxy_targets + 0]
    test rax, rax
    jz proxy_version_GetFileVersionInfoA_resolve
    jmp rax
proxy_version_GetFileVersionInfoA_resolve:
    mov r11d, 0
    jmp proxy_resolve_common
.globl proxy_version_GetFileVersionInfoByHandle
proxy_version_GetFileVersionInfoByHandle:
    mov rax, qword ptr [rip + glass_proxy_targets + 8]
    test rax, rax
    jz proxy_version_GetFileVersionInfoByHandle_resolve
    jmp rax
proxy_version_GetFileVersionInfoByHandle_resolve:
    mov r11d, 1
    jmp proxy_resolve_common
.globl proxy_version_GetFileVersionInfoExA
proxy_version_GetFileVersionInfoExA:
    mov rax, qword ptr [rip + glass_proxy_targets + 16]
    test rax, rax
    jz proxy_version_GetFileVersionInfoExA_resolve
    jmp rax
proxy_version_GetFileVersionInfoExA_resolve:
    mov r11d, 2
    jmp proxy_resolve_common
.globl proxy_version_GetFileVersionInfoExW
proxy_version_GetFileVersionInfoExW:
    mov rax, qword ptr [rip + glass_proxy_targets + 24]
    test rax, rax
    jz proxy_version_GetFileVersionInfoExW_resolve
    jmp rax
proxy_version_GetFileVersionInfoExW_resolve:
    mov r11d, 3
    jmp proxy_resolve_common
.globl proxy_version_GetFileVersionInfoSizeA
proxy_version_GetFileVersionInfoSizeA:
    mov rax, qword ptr [rip + glass_proxy_targets + 32]
    test rax, rax
    jz proxy_version_GetFileVersionInfoSizeA_resolve
    jmp rax
proxy_version_GetFileVersionInfoSizeA_resolve:
    mov r11d, 4
    jmp proxy_resolve_common
.globl proxy_version_GetFileVersionInfoSizeExA
proxy_version_GetFileVersionInfoSizeExA:
    mov rax, qword ptr [rip + glass_proxy_targets + 40]
    test rax, rax
    jz proxy_version_GetFileVersionInfoSizeExA_resolve
    jmp rax
proxy_version_GetFileVersionInfoSizeExA_resolve:
    mov r11d, 5
    jmp proxy_resolve_common
.globl proxy_version_GetFileVersionInfoSizeExW
proxy_version_GetFileVersionInfoSizeExW:
    mov rax, qword ptr [rip + glass_proxy_targets + 48]
    test rax, rax
    jz proxy_version_GetFileVersionInfoSizeExW_resolve
    jmp rax
proxy_version_GetFileVersionInfoSizeExW_resolve:
    mov r11d, 6
    jmp proxy_resolve_common
.globl proxy_version_GetFileVersionInfoSizeW
proxy_version_GetFileVersionInfoSizeW:
    mov rax, qword ptr [rip + glass_proxy_targets + 56]
    test rax, rax
    jz proxy_version_GetFileVersionInfoSizeW_resolve
    jmp rax
proxy_version_GetFileVersionInfoSizeW_resolve:
    mov r11d, 7
    jmp proxy_resolve_common
.globl proxy_version_GetFileVersionInfoW
proxy_version_GetFileVersionInfoW:
    mov rax, qword ptr [rip + glass_proxy_targets + 64]
    test rax, rax
    jz proxy_version_GetFileVersionInfoW_resolve
    jmp rax
proxy_version_GetFileVersionInfoW_resolve:
    mov r11d, 8
    jmp proxy_resolve_common
.globl proxy_version_VerFindFileA
proxy_version_VerFindFileA:
    mov rax, qword ptr [rip + glass_proxy_targets + 72]
    test rax, rax
    jz proxy_version_VerFindFileA_resolve
    jmp rax
proxy_version_VerFindFileA_resolve:
    mov r11d, 9
    jmp proxy_resolve_common
.globl proxy_version_VerFindFileW
proxy_version_VerFindFileW:
    mov rax, qword ptr [rip + glass_proxy_targets + 80]
    test rax, rax
    jz proxy_version_VerFindFileW_resolve
    jmp rax
proxy_version_VerFindFileW_resolve:
    mov r11d, 10
    jmp proxy_resolve_common
.globl proxy_version_VerInstallFileA
proxy_version_VerInstallFileA:
    mov rax, qword ptr [rip + glass_proxy_targets + 88]
    test rax, rax
    jz proxy_version_VerInstallFileA_resolve
    jmp rax
proxy_version_VerInstallFileA_resolve:
    mov r11d, 11
    jmp proxy_resolve_common
.globl proxy_version_VerInstallFileW
proxy_version_VerInstallFileW:
    mov rax, qword ptr [rip + glass_proxy_targets + 96]
    test rax, rax
    jz proxy_version_VerInstallFileW_resolve
    jmp rax
proxy_version_VerInstallFileW_resolve:
    mov r11d, 12
    jmp proxy_resolve_common
.globl proxy_version_VerLanguageNameA
proxy_version_VerLanguageNameA:
    mov rax, qword ptr [rip + glass_proxy_targets + 104]
    test rax, rax
    jz proxy_version_VerLanguageNameA_resolve
    jmp rax
proxy_version_VerLanguageNameA_resolve:
    mov r11d, 13
    jmp proxy_resolve_common
.globl proxy_version_VerLanguageNameW
proxy_version_VerLanguageNameW:
    mov rax, qword ptr [rip + glass_proxy_targets + 112]
    test rax, rax
    jz proxy_version_VerLanguageNameW_resolve
    jmp rax
proxy_version_VerLanguageNameW_resolve:
    mov r11d, 14
    jmp proxy_resolve_common
.globl proxy_version_VerQueryValueA
proxy_version_VerQueryValueA:
    mov rax, qword ptr [rip + glass_proxy_targets + 120]
    test rax, rax
    jz proxy_version_VerQueryValueA_resolve
    jmp rax
proxy_version_VerQueryValueA_resolve:
    mov r11d, 15
    jmp proxy_resolve_common
.globl proxy_version_VerQueryValueW
proxy_version_VerQueryValueW:
    mov rax, qword ptr [rip + glass_proxy_targets + 128]
    test rax, rax
    jz proxy_version_VerQueryValueW_resolve
    jmp rax
proxy_version_VerQueryValueW_resolve:
    mov r11d, 16
    jmp proxy_resolve_common
.globl proxy_winmm_CloseDriver
proxy_winmm_CloseDriver:
    mov rax, qword ptr [rip + glass_proxy_targets + 136]
    test rax, rax
    jz proxy_winmm_CloseDriver_resolve
    jmp rax
proxy_winmm_CloseDriver_resolve:
    mov r11d, 17
    jmp proxy_resolve_common
.globl proxy_winmm_DefDriverProc
proxy_winmm_DefDriverProc:
    mov rax, qword ptr [rip + glass_proxy_targets + 144]
    test rax, rax
    jz proxy_winmm_DefDriverProc_resolve
    jmp rax
proxy_winmm_DefDriverProc_resolve:
    mov r11d, 18
    jmp proxy_resolve_common
.globl proxy_winmm_DriverCallback
proxy_winmm_DriverCallback:
    mov rax, qword ptr [rip + glass_proxy_targets + 152]
    test rax, rax
    jz proxy_winmm_DriverCallback_resolve
    jmp rax
proxy_winmm_DriverCallback_resolve:
    mov r11d, 19
    jmp proxy_resolve_common
.globl proxy_winmm_DrvGetModuleHandle
proxy_winmm_DrvGetModuleHandle:
    mov rax, qword ptr [rip + glass_proxy_targets + 160]
    test rax, rax
    jz proxy_winmm_DrvGetModuleHandle_resolve
    jmp rax
proxy_winmm_DrvGetModuleHandle_resolve:
    mov r11d, 20
    jmp proxy_resolve_common
.globl proxy_winmm_GetDriverModuleHandle
proxy_winmm_GetDriverModuleHandle:
    mov rax, qword ptr [rip + glass_proxy_targets + 168]
    test rax, rax
    jz proxy_winmm_GetDriverModuleHandle_resolve
    jmp rax
proxy_winmm_GetDriverModuleHandle_resolve:
    mov r11d, 21
    jmp proxy_resolve_common
.globl proxy_winmm_OpenDriver
proxy_winmm_OpenDriver:
    mov rax, qword ptr [rip + glass_proxy_targets + 176]
    test rax, rax
    jz proxy_winmm_OpenDriver_resolve
    jmp rax
proxy_winmm_OpenDriver_resolve:
    mov r11d, 22
    jmp proxy_resolve_common
.globl proxy_winmm_PlaySound
proxy_winmm_PlaySound:
    mov rax, qword ptr [rip + glass_proxy_targets + 184]
    test rax, rax
    jz proxy_winmm_PlaySound_resolve
    jmp rax
proxy_winmm_PlaySound_resolve:
    mov r11d, 23
    jmp proxy_resolve_common
.globl proxy_winmm_PlaySoundA
proxy_winmm_PlaySoundA:
    mov rax, qword ptr [rip + glass_proxy_targets + 192]
    test rax, rax
    jz proxy_winmm_PlaySoundA_resolve
    jmp rax
proxy_winmm_PlaySoundA_resolve:
    mov r11d, 24
    jmp proxy_resolve_common
.globl proxy_winmm_PlaySoundW
proxy_winmm_PlaySoundW:
    mov rax, qword ptr [rip + glass_proxy_targets + 200]
    test rax, rax
    jz proxy_winmm_PlaySoundW_resolve
    jmp rax
proxy_winmm_PlaySoundW_resolve:
    mov r11d, 25
    jmp proxy_resolve_common
.globl proxy_winmm_SendDriverMessage
proxy_winmm_SendDriverMessage:
    mov rax, qword ptr [rip + glass_proxy_targets + 208]
    test rax, rax
    jz proxy_winmm_SendDriverMessage_resolve
    jmp rax
proxy_winmm_SendDriverMessage_resolve:
    mov r11d, 26
    jmp proxy_resolve_common
.globl proxy_winmm_WOWAppExit
proxy_winmm_WOWAppExit:
    mov rax, qword ptr [rip + glass_proxy_targets + 216]
    test rax, rax
    jz proxy_winmm_WOWAppExit_resolve
    jmp rax
proxy_winmm_WOWAppExit_resolve:
    mov r11d, 27
    jmp proxy_resolve_common
.globl proxy_winmm_auxGetDevCapsA
proxy_winmm_auxGetDevCapsA:
    mov rax, qword ptr [rip + glass_proxy_targets + 224]
    test rax, rax
    jz proxy_winmm_auxGetDevCapsA_resolve
    jmp rax
proxy_winmm_auxGetDevCapsA_resolve:
    mov r11d, 28
    jmp proxy_resolve_common
.globl proxy_winmm_auxGetDevCapsW
proxy_winmm_auxGetDevCapsW:
    mov rax, qword ptr [rip + glass_proxy_targets + 232]
    test rax, rax
    jz proxy_winmm_auxGetDevCapsW_resolve
    jmp rax
proxy_winmm_auxGetDevCapsW_resolve:
    mov r11d, 29
    jmp proxy_resolve_common
.globl proxy_winmm_auxGetNumDevs
proxy_winmm_auxGetNumDevs:
    mov rax, qword ptr [rip + glass_proxy_targets + 240]
    test rax, rax
    jz proxy_winmm_auxGetNumDevs_resolve
    jmp rax
proxy_winmm_auxGetNumDevs_resolve:
    mov r11d, 30
    jmp proxy_resolve_common
.globl proxy_winmm_auxGetVolume
proxy_winmm_auxGetVolume:
    mov rax, qword ptr [rip + glass_proxy_targets + 248]
    test rax, rax
    jz proxy_winmm_auxGetVolume_resolve
    jmp rax
proxy_winmm_auxGetVolume_resolve:
    mov r11d, 31
    jmp proxy_resolve_common
.globl proxy_winmm_auxOutMessage
proxy_winmm_auxOutMessage:
    mov rax, qword ptr [rip + glass_proxy_targets + 256]
    test rax, rax
    jz proxy_winmm_auxOutMessage_resolve
    jmp rax
proxy_winmm_auxOutMessage_resolve:
    mov r11d, 32
    jmp proxy_resolve_common
.globl proxy_winmm_auxSetVolume
proxy_winmm_auxSetVolume:
    mov rax, qword ptr [rip + glass_proxy_targets + 264]
    test rax, rax
    jz proxy_winmm_auxSetVolume_resolve
    jmp rax
proxy_winmm_auxSetVolume_resolve:
    mov r11d, 33
    jmp proxy_resolve_common
.globl proxy_winmm_joyConfigChanged
proxy_winmm_joyConfigChanged:
    mov rax, qword ptr [rip + glass_proxy_targets + 272]
    test rax, rax
    jz proxy_winmm_joyConfigChanged_resolve
    jmp rax
proxy_winmm_joyConfigChanged_resolve:
    mov r11d, 34
    jmp proxy_resolve_common
.globl proxy_winmm_joyGetDevCapsA
proxy_winmm_joyGetDevCapsA:
    mov rax, qword ptr [rip + glass_proxy_targets + 280]
    test rax, rax
    jz proxy_winmm_joyGetDevCapsA_resolve
    jmp rax
proxy_winmm_joyGetDevCapsA_resolve:
    mov r11d, 35
    jmp proxy_resolve_common
.globl proxy_winmm_joyGetDevCapsW
proxy_winmm_joyGetDevCapsW:
    mov rax, qword ptr [rip + glass_proxy_targets + 288]
    test rax, rax
    jz proxy_winmm_joyGetDevCapsW_resolve
    jmp rax
proxy_winmm_joyGetDevCapsW_resolve:
    mov r11d, 36
    jmp proxy_resolve_common
.globl proxy_winmm_joyGetNumDevs
proxy_winmm_joyGetNumDevs:
    mov rax, qword ptr [rip + glass_proxy_targets + 296]
    test rax, rax
    jz proxy_winmm_joyGetNumDevs_resolve
    jmp rax
proxy_winmm_joyGetNumDevs_resolve:
    mov r11d, 37
    jmp proxy_resolve_common
.globl proxy_winmm_joyGetPos
proxy_winmm_joyGetPos:
    mov rax, qword ptr [rip + glass_proxy_targets + 304]
    test rax, rax
    jz proxy_winmm_joyGetPos_resolve
    jmp rax
proxy_winmm_joyGetPos_resolve:
    mov r11d, 38
    jmp proxy_resolve_common
.globl proxy_winmm_joyGetPosEx
proxy_winmm_joyGetPosEx:
    mov rax, qword ptr [rip + glass_proxy_targets + 312]
    test rax, rax
    jz proxy_winmm_joyGetPosEx_resolve
    jmp rax
proxy_winmm_joyGetPosEx_resolve:
    mov r11d, 39
    jmp proxy_resolve_common
.globl proxy_winmm_joyGetThreshold
proxy_winmm_joyGetThreshold:
    mov rax, qword ptr [rip + glass_proxy_targets + 320]
    test rax, rax
    jz proxy_winmm_joyGetThreshold_resolve
    jmp rax
proxy_winmm_joyGetThreshold_resolve:
    mov r11d, 40
    jmp proxy_resolve_common
.globl proxy_winmm_joyReleaseCapture
proxy_winmm_joyReleaseCapture:
    mov rax, qword ptr [rip + glass_proxy_targets + 328]
    test rax, rax
    jz proxy_winmm_joyReleaseCapture_resolve
    jmp rax
proxy_winmm_joyReleaseCapture_resolve:
    mov r11d, 41
    jmp proxy_resolve_common
.globl proxy_winmm_joySetCapture
proxy_winmm_joySetCapture:
    mov rax, qword ptr [rip + glass_proxy_targets + 336]
    test rax, rax
    jz proxy_winmm_joySetCapture_resolve
    jmp rax
proxy_winmm_joySetCapture_resolve:
    mov r11d, 42
    jmp proxy_resolve_common
.globl proxy_winmm_joySetThreshold
proxy_winmm_joySetThreshold:
    mov rax, qword ptr [rip + glass_proxy_targets + 344]
    test rax, rax
    jz proxy_winmm_joySetThreshold_resolve
    jmp rax
proxy_winmm_joySetThreshold_resolve:
    mov r11d, 43
    jmp proxy_resolve_common
.globl proxy_winmm_mciDriverNotify
proxy_winmm_mciDriverNotify:
    mov rax, qword ptr [rip + glass_proxy_targets + 352]
    test rax, rax
    jz proxy_winmm_mciDriverNotify_resolve
    jmp rax
proxy_winmm_mciDriverNotify_resolve:
    mov r11d, 44
    jmp proxy_resolve_common
.globl proxy_winmm_mciDriverYield
proxy_winmm_mciDriverYield:
    mov rax, qword ptr [rip + glass_proxy_targets + 360]
    test rax, rax
    jz proxy_winmm_mciDriverYield_resolve
    jmp rax
proxy_winmm_mciDriverYield_resolve:
    mov r11d, 45
    jmp proxy_resolve_common
.globl proxy_winmm_mciExecute
proxy_winmm_mciExecute:
    mov rax, qword ptr [rip + glass_proxy_targets + 368]
    test rax, rax
    jz proxy_winmm_mciExecute_resolve
    jmp rax
proxy_winmm_mciExecute_resolve:
    mov r11d, 46
    jmp proxy_resolve_common
.globl proxy_winmm_mciFreeCommandResource
proxy_winmm_mciFreeCommandResource:
    mov rax, qword ptr [rip + glass_proxy_targets + 376]
    test rax, rax
    jz proxy_winmm_mciFreeCommandResource_resolve
    jmp rax
proxy_winmm_mciFreeCommandResource_resolve:
    mov r11d, 47
    jmp proxy_resolve_common
.globl proxy_winmm_mciGetCreatorTask
proxy_winmm_mciGetCreatorTask:
    mov rax, qword ptr [rip + glass_proxy_targets + 384]
    test rax, rax
    jz proxy_winmm_mciGetCreatorTask_resolve
    jmp rax
proxy_winmm_mciGetCreatorTask_resolve:
    mov r11d, 48
    jmp proxy_resolve_common
.globl proxy_winmm_mciGetDeviceIDA
proxy_winmm_mciGetDeviceIDA:
    mov rax, qword ptr [rip + glass_proxy_targets + 392]
    test rax, rax
    jz proxy_winmm_mciGetDeviceIDA_resolve
    jmp rax
proxy_winmm_mciGetDeviceIDA_resolve:
    mov r11d, 49
    jmp proxy_resolve_common
.globl proxy_winmm_mciGetDeviceIDFromElementIDA
proxy_winmm_mciGetDeviceIDFromElementIDA:
    mov rax, qword ptr [rip + glass_proxy_targets + 400]
    test rax, rax
    jz proxy_winmm_mciGetDeviceIDFromElementIDA_resolve
    jmp rax
proxy_winmm_mciGetDeviceIDFromElementIDA_resolve:
    mov r11d, 50
    jmp proxy_resolve_common
.globl proxy_winmm_mciGetDeviceIDFromElementIDW
proxy_winmm_mciGetDeviceIDFromElementIDW:
    mov rax, qword ptr [rip + glass_proxy_targets + 408]
    test rax, rax
    jz proxy_winmm_mciGetDeviceIDFromElementIDW_resolve
    jmp rax
proxy_winmm_mciGetDeviceIDFromElementIDW_resolve:
    mov r11d, 51
    jmp proxy_resolve_common
.globl proxy_winmm_mciGetDeviceIDW
proxy_winmm_mciGetDeviceIDW:
    mov rax, qword ptr [rip + glass_proxy_targets + 416]
    test rax, rax
    jz proxy_winmm_mciGetDeviceIDW_resolve
    jmp rax
proxy_winmm_mciGetDeviceIDW_resolve:
    mov r11d, 52
    jmp proxy_resolve_common
.globl proxy_winmm_mciGetDriverData
proxy_winmm_mciGetDriverData:
    mov rax, qword ptr [rip + glass_proxy_targets + 424]
    test rax, rax
    jz proxy_winmm_mciGetDriverData_resolve
    jmp rax
proxy_winmm_mciGetDriverData_resolve:
    mov r11d, 53
    jmp proxy_resolve_common
.globl proxy_winmm_mciGetErrorStringA
proxy_winmm_mciGetErrorStringA:
    mov rax, qword ptr [rip + glass_proxy_targets + 432]
    test rax, rax
    jz proxy_winmm_mciGetErrorStringA_resolve
    jmp rax
proxy_winmm_mciGetErrorStringA_resolve:
    mov r11d, 54
    jmp proxy_resolve_common
.globl proxy_winmm_mciGetErrorStringW
proxy_winmm_mciGetErrorStringW:
    mov rax, qword ptr [rip + glass_proxy_targets + 440]
    test rax, rax
    jz proxy_winmm_mciGetErrorStringW_resolve
    jmp rax
proxy_winmm_mciGetErrorStringW_resolve:
    mov r11d, 55
    jmp proxy_resolve_common
.globl proxy_winmm_mciGetYieldProc
proxy_winmm_mciGetYieldProc:
    mov rax, qword ptr [rip + glass_proxy_targets + 448]
    test rax, rax
    jz proxy_winmm_mciGetYieldProc_resolve
    jmp rax
proxy_winmm_mciGetYieldProc_resolve:
    mov r11d, 56
    jmp proxy_resolve_common
.globl proxy_winmm_mciLoadCommandResource
proxy_winmm_mciLoadCommandResource:
    mov rax, qword ptr [rip + glass_proxy_targets + 456]
    test rax, rax
    jz proxy_winmm_mciLoadCommandResource_resolve
    jmp rax
proxy_winmm_mciLoadCommandResource_resolve:
    mov r11d, 57
    jmp proxy_resolve_common
.globl proxy_winmm_mciSendCommandA
proxy_winmm_mciSendCommandA:
    mov rax, qword ptr [rip + glass_proxy_targets + 464]
    test rax, rax
    jz proxy_winmm_mciSendCommandA_resolve
    jmp rax
proxy_winmm_mciSendCommandA_resolve:
    mov r11d, 58
    jmp proxy_resolve_common
.globl proxy_winmm_mciSendCommandW
proxy_winmm_mciSendCommandW:
    mov rax, qword ptr [rip + glass_proxy_targets + 472]
    test rax, rax
    jz proxy_winmm_mciSendCommandW_resolve
    jmp rax
proxy_winmm_mciSendCommandW_resolve:
    mov r11d, 59
    jmp proxy_resolve_common
.globl proxy_winmm_mciSendStringA
proxy_winmm_mciSendStringA:
    mov rax, qword ptr [rip + glass_proxy_targets + 480]
    test rax, rax
    jz proxy_winmm_mciSendStringA_resolve
    jmp rax
proxy_winmm_mciSendStringA_resolve:
    mov r11d, 60
    jmp proxy_resolve_common
.globl proxy_winmm_mciSendStringW
proxy_winmm_mciSendStringW:
    mov rax, qword ptr [rip + glass_proxy_targets + 488]
    test rax, rax
    jz proxy_winmm_mciSendStringW_resolve
    jmp rax
proxy_winmm_mciSendStringW_resolve:
    mov r11d, 61
    jmp proxy_resolve_common
.globl proxy_winmm_mciSetDriverData
proxy_winmm_mciSetDriverData:
    mov rax, qword ptr [rip + glass_proxy_targets + 496]
    test rax, rax
    jz proxy_winmm_mciSetDriverData_resolve
    jmp rax
proxy_winmm_mciSetDriverData_resolve:
    mov r11d, 62
    jmp proxy_resolve_common
.globl proxy_winmm_mciSetYieldProc
proxy_winmm_mciSetYieldProc:
    mov rax, qword ptr [rip + glass_proxy_targets + 504]
    test rax, rax
    jz proxy_winmm_mciSetYieldProc_resolve
    jmp rax
proxy_winmm_mciSetYieldProc_resolve:
    mov r11d, 63
    jmp proxy_resolve_common
.globl proxy_winmm_midiConnect
proxy_winmm_midiConnect:
    mov rax, qword ptr [rip + glass_proxy_targets + 512]
    test rax, rax
    jz proxy_winmm_midiConnect_resolve
    jmp rax
proxy_winmm_midiConnect_resolve:
    mov r11d, 64
    jmp proxy_resolve_common
.globl proxy_winmm_midiDisconnect
proxy_winmm_midiDisconnect:
    mov rax, qword ptr [rip + glass_proxy_targets + 520]
    test rax, rax
    jz proxy_winmm_midiDisconnect_resolve
    jmp rax
proxy_winmm_midiDisconnect_resolve:
    mov r11d, 65
    jmp proxy_resolve_common
.globl proxy_winmm_midiInAddBuffer
proxy_winmm_midiInAddBuffer:
    mov rax, qword ptr [rip + glass_proxy_targets + 528]
    test rax, rax
    jz proxy_winmm_midiInAddBuffer_resolve
    jmp rax
proxy_winmm_midiInAddBuffer_resolve:
    mov r11d, 66
    jmp proxy_resolve_common
.globl proxy_winmm_midiInClose
proxy_winmm_midiInClose:
    mov rax, qword ptr [rip + glass_proxy_targets + 536]
    test rax, rax
    jz proxy_winmm_midiInClose_resolve
    jmp rax
proxy_winmm_midiInClose_resolve:
    mov r11d, 67
    jmp proxy_resolve_common
.globl proxy_winmm_midiInGetDevCapsA
proxy_winmm_midiInGetDevCapsA:
    mov rax, qword ptr [rip + glass_proxy_targets + 544]
    test rax, rax
    jz proxy_winmm_midiInGetDevCapsA_resolve
    jmp rax
proxy_winmm_midiInGetDevCapsA_resolve:
    mov r11d, 68
    jmp proxy_resolve_common
.globl proxy_winmm_midiInGetDevCapsW
proxy_winmm_midiInGetDevCapsW:
    mov rax, qword ptr [rip + glass_proxy_targets + 552]
    test rax, rax
    jz proxy_winmm_midiInGetDevCapsW_resolve
    jmp rax
proxy_winmm_midiInGetDevCapsW_resolve:
    mov r11d, 69
    jmp proxy_resolve_common
.globl proxy_winmm_midiInGetErrorTextA
proxy_winmm_midiInGetErrorTextA:
    mov rax, qword ptr [rip + glass_proxy_targets + 560]
    test rax, rax
    jz proxy_winmm_midiInGetErrorTextA_resolve
    jmp rax
proxy_winmm_midiInGetErrorTextA_resolve:
    mov r11d, 70
    jmp proxy_resolve_common
.globl proxy_winmm_midiInGetErrorTextW
proxy_winmm_midiInGetErrorTextW:
    mov rax, qword ptr [rip + glass_proxy_targets + 568]
    test rax, rax
    jz proxy_winmm_midiInGetErrorTextW_resolve
    jmp rax
proxy_winmm_midiInGetErrorTextW_resolve:
    mov r11d, 71
    jmp proxy_resolve_common
.globl proxy_winmm_midiInGetID
proxy_winmm_midiInGetID:
    mov rax, qword ptr [rip + glass_proxy_targets + 576]
    test rax, rax
    jz proxy_winmm_midiInGetID_resolve
    jmp rax
proxy_winmm_midiInGetID_resolve:
    mov r11d, 72
    jmp proxy_resolve_common
.globl proxy_winmm_midiInGetNumDevs
proxy_winmm_midiInGetNumDevs:
    mov rax, qword ptr [rip + glass_proxy_targets + 584]
    test rax, rax
    jz proxy_winmm_midiInGetNumDevs_resolve
    jmp rax
proxy_winmm_midiInGetNumDevs_resolve:
    mov r11d, 73
    jmp proxy_resolve_common
.globl proxy_winmm_midiInMessage
proxy_winmm_midiInMessage:
    mov rax, qword ptr [rip + glass_proxy_targets + 592]
    test rax, rax
    jz proxy_winmm_midiInMessage_resolve
    jmp rax
proxy_winmm_midiInMessage_resolve:
    mov r11d, 74
    jmp proxy_resolve_common
.globl proxy_winmm_midiInOpen
proxy_winmm_midiInOpen:
    mov rax, qword ptr [rip + glass_proxy_targets + 600]
    test rax, rax
    jz proxy_winmm_midiInOpen_resolve
    jmp rax
proxy_winmm_midiInOpen_resolve:
    mov r11d, 75
    jmp proxy_resolve_common
.globl proxy_winmm_midiInPrepareHeader
proxy_winmm_midiInPrepareHeader:
    mov rax, qword ptr [rip + glass_proxy_targets + 608]
    test rax, rax
    jz proxy_winmm_midiInPrepareHeader_resolve
    jmp rax
proxy_winmm_midiInPrepareHeader_resolve:
    mov r11d, 76
    jmp proxy_resolve_common
.globl proxy_winmm_midiInReset
proxy_winmm_midiInReset:
    mov rax, qword ptr [rip + glass_proxy_targets + 616]
    test rax, rax
    jz proxy_winmm_midiInReset_resolve
    jmp rax
proxy_winmm_midiInReset_resolve:
    mov r11d, 77
    jmp proxy_resolve_common
.globl proxy_winmm_midiInStart
proxy_winmm_midiInStart:
    mov rax, qword ptr [rip + glass_proxy_targets + 624]
    test rax, rax
    jz proxy_winmm_midiInStart_resolve
    jmp rax
proxy_winmm_midiInStart_resolve:
    mov r11d, 78
    jmp proxy_resolve_common
.globl proxy_winmm_midiInStop
proxy_winmm_midiInStop:
    mov rax, qword ptr [rip + glass_proxy_targets + 632]
    test rax, rax
    jz proxy_winmm_midiInStop_resolve
    jmp rax
proxy_winmm_midiInStop_resolve:
    mov r11d, 79
    jmp proxy_resolve_common
.globl proxy_winmm_midiInUnprepareHeader
proxy_winmm_midiInUnprepareHeader:
    mov rax, qword ptr [rip + glass_proxy_targets + 640]
    test rax, rax
    jz proxy_winmm_midiInUnprepareHeader_resolve
    jmp rax
proxy_winmm_midiInUnprepareHeader_resolve:
    mov r11d, 80
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutCacheDrumPatches
proxy_winmm_midiOutCacheDrumPatches:
    mov rax, qword ptr [rip + glass_proxy_targets + 648]
    test rax, rax
    jz proxy_winmm_midiOutCacheDrumPatches_resolve
    jmp rax
proxy_winmm_midiOutCacheDrumPatches_resolve:
    mov r11d, 81
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutCachePatches
proxy_winmm_midiOutCachePatches:
    mov rax, qword ptr [rip + glass_proxy_targets + 656]
    test rax, rax
    jz proxy_winmm_midiOutCachePatches_resolve
    jmp rax
proxy_winmm_midiOutCachePatches_resolve:
    mov r11d, 82
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutClose
proxy_winmm_midiOutClose:
    mov rax, qword ptr [rip + glass_proxy_targets + 664]
    test rax, rax
    jz proxy_winmm_midiOutClose_resolve
    jmp rax
proxy_winmm_midiOutClose_resolve:
    mov r11d, 83
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutGetDevCapsA
proxy_winmm_midiOutGetDevCapsA:
    mov rax, qword ptr [rip + glass_proxy_targets + 672]
    test rax, rax
    jz proxy_winmm_midiOutGetDevCapsA_resolve
    jmp rax
proxy_winmm_midiOutGetDevCapsA_resolve:
    mov r11d, 84
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutGetDevCapsW
proxy_winmm_midiOutGetDevCapsW:
    mov rax, qword ptr [rip + glass_proxy_targets + 680]
    test rax, rax
    jz proxy_winmm_midiOutGetDevCapsW_resolve
    jmp rax
proxy_winmm_midiOutGetDevCapsW_resolve:
    mov r11d, 85
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutGetErrorTextA
proxy_winmm_midiOutGetErrorTextA:
    mov rax, qword ptr [rip + glass_proxy_targets + 688]
    test rax, rax
    jz proxy_winmm_midiOutGetErrorTextA_resolve
    jmp rax
proxy_winmm_midiOutGetErrorTextA_resolve:
    mov r11d, 86
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutGetErrorTextW
proxy_winmm_midiOutGetErrorTextW:
    mov rax, qword ptr [rip + glass_proxy_targets + 696]
    test rax, rax
    jz proxy_winmm_midiOutGetErrorTextW_resolve
    jmp rax
proxy_winmm_midiOutGetErrorTextW_resolve:
    mov r11d, 87
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutGetID
proxy_winmm_midiOutGetID:
    mov rax, qword ptr [rip + glass_proxy_targets + 704]
    test rax, rax
    jz proxy_winmm_midiOutGetID_resolve
    jmp rax
proxy_winmm_midiOutGetID_resolve:
    mov r11d, 88
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutGetNumDevs
proxy_winmm_midiOutGetNumDevs:
    mov rax, qword ptr [rip + glass_proxy_targets + 712]
    test rax, rax
    jz proxy_winmm_midiOutGetNumDevs_resolve
    jmp rax
proxy_winmm_midiOutGetNumDevs_resolve:
    mov r11d, 89
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutGetVolume
proxy_winmm_midiOutGetVolume:
    mov rax, qword ptr [rip + glass_proxy_targets + 720]
    test rax, rax
    jz proxy_winmm_midiOutGetVolume_resolve
    jmp rax
proxy_winmm_midiOutGetVolume_resolve:
    mov r11d, 90
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutLongMsg
proxy_winmm_midiOutLongMsg:
    mov rax, qword ptr [rip + glass_proxy_targets + 728]
    test rax, rax
    jz proxy_winmm_midiOutLongMsg_resolve
    jmp rax
proxy_winmm_midiOutLongMsg_resolve:
    mov r11d, 91
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutMessage
proxy_winmm_midiOutMessage:
    mov rax, qword ptr [rip + glass_proxy_targets + 736]
    test rax, rax
    jz proxy_winmm_midiOutMessage_resolve
    jmp rax
proxy_winmm_midiOutMessage_resolve:
    mov r11d, 92
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutOpen
proxy_winmm_midiOutOpen:
    mov rax, qword ptr [rip + glass_proxy_targets + 744]
    test rax, rax
    jz proxy_winmm_midiOutOpen_resolve
    jmp rax
proxy_winmm_midiOutOpen_resolve:
    mov r11d, 93
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutPrepareHeader
proxy_winmm_midiOutPrepareHeader:
    mov rax, qword ptr [rip + glass_proxy_targets + 752]
    test rax, rax
    jz proxy_winmm_midiOutPrepareHeader_resolve
    jmp rax
proxy_winmm_midiOutPrepareHeader_resolve:
    mov r11d, 94
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutReset
proxy_winmm_midiOutReset:
    mov rax, qword ptr [rip + glass_proxy_targets + 760]
    test rax, rax
    jz proxy_winmm_midiOutReset_resolve
    jmp rax
proxy_winmm_midiOutReset_resolve:
    mov r11d, 95
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutSetVolume
proxy_winmm_midiOutSetVolume:
    mov rax, qword ptr [rip + glass_proxy_targets + 768]
    test rax, rax
    jz proxy_winmm_midiOutSetVolume_resolve
    jmp rax
proxy_winmm_midiOutSetVolume_resolve:
    mov r11d, 96
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutShortMsg
proxy_winmm_midiOutShortMsg:
    mov rax, qword ptr [rip + glass_proxy_targets + 776]
    test rax, rax
    jz proxy_winmm_midiOutShortMsg_resolve
    jmp rax
proxy_winmm_midiOutShortMsg_resolve:
    mov r11d, 97
    jmp proxy_resolve_common
.globl proxy_winmm_midiOutUnprepareHeader
proxy_winmm_midiOutUnprepareHeader:
    mov rax, qword ptr [rip + glass_proxy_targets + 784]
    test rax, rax
    jz proxy_winmm_midiOutUnprepareHeader_resolve
    jmp rax
proxy_winmm_midiOutUnprepareHeader_resolve:
    mov r11d, 98
    jmp proxy_resolve_common
.globl proxy_winmm_midiStreamClose
proxy_winmm_midiStreamClose:
    mov rax, qword ptr [rip + glass_proxy_targets + 792]
    test rax, rax
    jz proxy_winmm_midiStreamClose_resolve
    jmp rax
proxy_winmm_midiStreamClose_resolve:
    mov r11d, 99
    jmp proxy_resolve_common
.globl proxy_winmm_midiStreamOpen
proxy_winmm_midiStreamOpen:
    mov rax, qword ptr [rip + glass_proxy_targets + 800]
    test rax, rax
    jz proxy_winmm_midiStreamOpen_resolve
    jmp rax
proxy_winmm_midiStreamOpen_resolve:
    mov r11d, 100
    jmp proxy_resolve_common
.globl proxy_winmm_midiStreamOut
proxy_winmm_midiStreamOut:
    mov rax, qword ptr [rip + glass_proxy_targets + 808]
    test rax, rax
    jz proxy_winmm_midiStreamOut_resolve
    jmp rax
proxy_winmm_midiStreamOut_resolve:
    mov r11d, 101
    jmp proxy_resolve_common
.globl proxy_winmm_midiStreamPause
proxy_winmm_midiStreamPause:
    mov rax, qword ptr [rip + glass_proxy_targets + 816]
    test rax, rax
    jz proxy_winmm_midiStreamPause_resolve
    jmp rax
proxy_winmm_midiStreamPause_resolve:
    mov r11d, 102
    jmp proxy_resolve_common
.globl proxy_winmm_midiStreamPosition
proxy_winmm_midiStreamPosition:
    mov rax, qword ptr [rip + glass_proxy_targets + 824]
    test rax, rax
    jz proxy_winmm_midiStreamPosition_resolve
    jmp rax
proxy_winmm_midiStreamPosition_resolve:
    mov r11d, 103
    jmp proxy_resolve_common
.globl proxy_winmm_midiStreamProperty
proxy_winmm_midiStreamProperty:
    mov rax, qword ptr [rip + glass_proxy_targets + 832]
    test rax, rax
    jz proxy_winmm_midiStreamProperty_resolve
    jmp rax
proxy_winmm_midiStreamProperty_resolve:
    mov r11d, 104
    jmp proxy_resolve_common
.globl proxy_winmm_midiStreamRestart
proxy_winmm_midiStreamRestart:
    mov rax, qword ptr [rip + glass_proxy_targets + 840]
    test rax, rax
    jz proxy_winmm_midiStreamRestart_resolve
    jmp rax
proxy_winmm_midiStreamRestart_resolve:
    mov r11d, 105
    jmp proxy_resolve_common
.globl proxy_winmm_midiStreamStop
proxy_winmm_midiStreamStop:
    mov rax, qword ptr [rip + glass_proxy_targets + 848]
    test rax, rax
    jz proxy_winmm_midiStreamStop_resolve
    jmp rax
proxy_winmm_midiStreamStop_resolve:
    mov r11d, 106
    jmp proxy_resolve_common
.globl proxy_winmm_mixerClose
proxy_winmm_mixerClose:
    mov rax, qword ptr [rip + glass_proxy_targets + 856]
    test rax, rax
    jz proxy_winmm_mixerClose_resolve
    jmp rax
proxy_winmm_mixerClose_resolve:
    mov r11d, 107
    jmp proxy_resolve_common
.globl proxy_winmm_mixerGetControlDetailsA
proxy_winmm_mixerGetControlDetailsA:
    mov rax, qword ptr [rip + glass_proxy_targets + 864]
    test rax, rax
    jz proxy_winmm_mixerGetControlDetailsA_resolve
    jmp rax
proxy_winmm_mixerGetControlDetailsA_resolve:
    mov r11d, 108
    jmp proxy_resolve_common
.globl proxy_winmm_mixerGetControlDetailsW
proxy_winmm_mixerGetControlDetailsW:
    mov rax, qword ptr [rip + glass_proxy_targets + 872]
    test rax, rax
    jz proxy_winmm_mixerGetControlDetailsW_resolve
    jmp rax
proxy_winmm_mixerGetControlDetailsW_resolve:
    mov r11d, 109
    jmp proxy_resolve_common
.globl proxy_winmm_mixerGetDevCapsA
proxy_winmm_mixerGetDevCapsA:
    mov rax, qword ptr [rip + glass_proxy_targets + 880]
    test rax, rax
    jz proxy_winmm_mixerGetDevCapsA_resolve
    jmp rax
proxy_winmm_mixerGetDevCapsA_resolve:
    mov r11d, 110
    jmp proxy_resolve_common
.globl proxy_winmm_mixerGetDevCapsW
proxy_winmm_mixerGetDevCapsW:
    mov rax, qword ptr [rip + glass_proxy_targets + 888]
    test rax, rax
    jz proxy_winmm_mixerGetDevCapsW_resolve
    jmp rax
proxy_winmm_mixerGetDevCapsW_resolve:
    mov r11d, 111
    jmp proxy_resolve_common
.globl proxy_winmm_mixerGetID
proxy_winmm_mixerGetID:
    mov rax, qword ptr [rip + glass_proxy_targets + 896]
    test rax, rax
    jz proxy_winmm_mixerGetID_resolve
    jmp rax
proxy_winmm_mixerGetID_resolve:
    mov r11d, 112
    jmp proxy_resolve_common
.globl proxy_winmm_mixerGetLineControlsA
proxy_winmm_mixerGetLineControlsA:
    mov rax, qword ptr [rip + glass_proxy_targets + 904]
    test rax, rax
    jz proxy_winmm_mixerGetLineControlsA_resolve
    jmp rax
proxy_winmm_mixerGetLineControlsA_resolve:
    mov r11d, 113
    jmp proxy_resolve_common
.globl proxy_winmm_mixerGetLineControlsW
proxy_winmm_mixerGetLineControlsW:
    mov rax, qword ptr [rip + glass_proxy_targets + 912]
    test rax, rax
    jz proxy_winmm_mixerGetLineControlsW_resolve
    jmp rax
proxy_winmm_mixerGetLineControlsW_resolve:
    mov r11d, 114
    jmp proxy_resolve_common
.globl proxy_winmm_mixerGetLineInfoA
proxy_winmm_mixerGetLineInfoA:
    mov rax, qword ptr [rip + glass_proxy_targets + 920]
    test rax, rax
    jz proxy_winmm_mixerGetLineInfoA_resolve
    jmp rax
proxy_winmm_mixerGetLineInfoA_resolve:
    mov r11d, 115
    jmp proxy_resolve_common
.globl proxy_winmm_mixerGetLineInfoW
proxy_winmm_mixerGetLineInfoW:
    mov rax, qword ptr [rip + glass_proxy_targets + 928]
    test rax, rax
    jz proxy_winmm_mixerGetLineInfoW_resolve
    jmp rax
proxy_winmm_mixerGetLineInfoW_resolve:
    mov r11d, 116
    jmp proxy_resolve_common
.globl proxy_winmm_mixerGetNumDevs
proxy_winmm_mixerGetNumDevs:
    mov rax, qword ptr [rip + glass_proxy_targets + 936]
    test rax, rax
    jz proxy_winmm_mixerGetNumDevs_resolve
    jmp rax
proxy_winmm_mixerGetNumDevs_resolve:
    mov r11d, 117
    jmp proxy_resolve_common
.globl proxy_winmm_mixerMessage
proxy_winmm_mixerMessage:
    mov rax, qword ptr [rip + glass_proxy_targets + 944]
    test rax, rax
    jz proxy_winmm_mixerMessage_resolve
    jmp rax
proxy_winmm_mixerMessage_resolve:
    mov r11d, 118
    jmp proxy_resolve_common
.globl proxy_winmm_mixerOpen
proxy_winmm_mixerOpen:
    mov rax, qword ptr [rip + glass_proxy_targets + 952]
    test rax, rax
    jz proxy_winmm_mixerOpen_resolve
    jmp rax
proxy_winmm_mixerOpen_resolve:
    mov r11d, 119
    jmp proxy_resolve_common
.globl proxy_winmm_mixerSetControlDetails
proxy_winmm_mixerSetControlDetails:
    mov rax, qword ptr [rip + glass_proxy_targets + 960]
    test rax, rax
    jz proxy_winmm_mixerSetControlDetails_resolve
    jmp rax
proxy_winmm_mixerSetControlDetails_resolve:
    mov r11d, 120
    jmp proxy_resolve_common
.globl proxy_winmm_mmDrvInstall
proxy_winmm_mmDrvInstall:
    mov rax, qword ptr [rip + glass_proxy_targets + 968]
    test rax, rax
    jz proxy_winmm_mmDrvInstall_resolve
    jmp rax
proxy_winmm_mmDrvInstall_resolve:
    mov r11d, 121
    jmp proxy_resolve_common
.globl proxy_winmm_mmGetCurrentTask
proxy_winmm_mmGetCurrentTask:
    mov rax, qword ptr [rip + glass_proxy_targets + 976]
    test rax, rax
    jz proxy_winmm_mmGetCurrentTask_resolve
    jmp rax
proxy_winmm_mmGetCurrentTask_resolve:
    mov r11d, 122
    jmp proxy_resolve_common
.globl proxy_winmm_mmTaskBlock
proxy_winmm_mmTaskBlock:
    mov rax, qword ptr [rip + glass_proxy_targets + 984]
    test rax, rax
    jz proxy_winmm_mmTaskBlock_resolve
    jmp rax
proxy_winmm_mmTaskBlock_resolve:
    mov r11d, 123
    jmp proxy_resolve_common
.globl proxy_winmm_mmTaskCreate
proxy_winmm_mmTaskCreate:
    mov rax, qword ptr [rip + glass_proxy_targets + 992]
    test rax, rax
    jz proxy_winmm_mmTaskCreate_resolve
    jmp rax
proxy_winmm_mmTaskCreate_resolve:
    mov r11d, 124
    jmp proxy_resolve_common
.globl proxy_winmm_mmTaskSignal
proxy_winmm_mmTaskSignal:
    mov rax, qword ptr [rip + glass_proxy_targets + 1000]
    test rax, rax
    jz proxy_winmm_mmTaskSignal_resolve
    jmp rax
proxy_winmm_mmTaskSignal_resolve:
    mov r11d, 125
    jmp proxy_resolve_common
.globl proxy_winmm_mmTaskYield
proxy_winmm_mmTaskYield:
    mov rax, qword ptr [rip + glass_proxy_targets + 1008]
    test rax, rax
    jz proxy_winmm_mmTaskYield_resolve
    jmp rax
proxy_winmm_mmTaskYield_resolve:
    mov r11d, 126
    jmp proxy_resolve_common
.globl proxy_winmm_mmioAdvance
proxy_winmm_mmioAdvance:
    mov rax, qword ptr [rip + glass_proxy_targets + 1016]
    test rax, rax
    jz proxy_winmm_mmioAdvance_resolve
    jmp rax
proxy_winmm_mmioAdvance_resolve:
    mov r11d, 127
    jmp proxy_resolve_common
.globl proxy_winmm_mmioAscend
proxy_winmm_mmioAscend:
    mov rax, qword ptr [rip + glass_proxy_targets + 1024]
    test rax, rax
    jz proxy_winmm_mmioAscend_resolve
    jmp rax
proxy_winmm_mmioAscend_resolve:
    mov r11d, 128
    jmp proxy_resolve_common
.globl proxy_winmm_mmioClose
proxy_winmm_mmioClose:
    mov rax, qword ptr [rip + glass_proxy_targets + 1032]
    test rax, rax
    jz proxy_winmm_mmioClose_resolve
    jmp rax
proxy_winmm_mmioClose_resolve:
    mov r11d, 129
    jmp proxy_resolve_common
.globl proxy_winmm_mmioCreateChunk
proxy_winmm_mmioCreateChunk:
    mov rax, qword ptr [rip + glass_proxy_targets + 1040]
    test rax, rax
    jz proxy_winmm_mmioCreateChunk_resolve
    jmp rax
proxy_winmm_mmioCreateChunk_resolve:
    mov r11d, 130
    jmp proxy_resolve_common
.globl proxy_winmm_mmioDescend
proxy_winmm_mmioDescend:
    mov rax, qword ptr [rip + glass_proxy_targets + 1048]
    test rax, rax
    jz proxy_winmm_mmioDescend_resolve
    jmp rax
proxy_winmm_mmioDescend_resolve:
    mov r11d, 131
    jmp proxy_resolve_common
.globl proxy_winmm_mmioFlush
proxy_winmm_mmioFlush:
    mov rax, qword ptr [rip + glass_proxy_targets + 1056]
    test rax, rax
    jz proxy_winmm_mmioFlush_resolve
    jmp rax
proxy_winmm_mmioFlush_resolve:
    mov r11d, 132
    jmp proxy_resolve_common
.globl proxy_winmm_mmioGetInfo
proxy_winmm_mmioGetInfo:
    mov rax, qword ptr [rip + glass_proxy_targets + 1064]
    test rax, rax
    jz proxy_winmm_mmioGetInfo_resolve
    jmp rax
proxy_winmm_mmioGetInfo_resolve:
    mov r11d, 133
    jmp proxy_resolve_common
.globl proxy_winmm_mmioInstallIOProcA
proxy_winmm_mmioInstallIOProcA:
    mov rax, qword ptr [rip + glass_proxy_targets + 1072]
    test rax, rax
    jz proxy_winmm_mmioInstallIOProcA_resolve
    jmp rax
proxy_winmm_mmioInstallIOProcA_resolve:
    mov r11d, 134
    jmp proxy_resolve_common
.globl proxy_winmm_mmioInstallIOProcW
proxy_winmm_mmioInstallIOProcW:
    mov rax, qword ptr [rip + glass_proxy_targets + 1080]
    test rax, rax
    jz proxy_winmm_mmioInstallIOProcW_resolve
    jmp rax
proxy_winmm_mmioInstallIOProcW_resolve:
    mov r11d, 135
    jmp proxy_resolve_common
.globl proxy_winmm_mmioOpenA
proxy_winmm_mmioOpenA:
    mov rax, qword ptr [rip + glass_proxy_targets + 1088]
    test rax, rax
    jz proxy_winmm_mmioOpenA_resolve
    jmp rax
proxy_winmm_mmioOpenA_resolve:
    mov r11d, 136
    jmp proxy_resolve_common
.globl proxy_winmm_mmioOpenW
proxy_winmm_mmioOpenW:
    mov rax, qword ptr [rip + glass_proxy_targets + 1096]
    test rax, rax
    jz proxy_winmm_mmioOpenW_resolve
    jmp rax
proxy_winmm_mmioOpenW_resolve:
    mov r11d, 137
    jmp proxy_resolve_common
.globl proxy_winmm_mmioRead
proxy_winmm_mmioRead:
    mov rax, qword ptr [rip + glass_proxy_targets + 1104]
    test rax, rax
    jz proxy_winmm_mmioRead_resolve
    jmp rax
proxy_winmm_mmioRead_resolve:
    mov r11d, 138
    jmp proxy_resolve_common
.globl proxy_winmm_mmioRenameA
proxy_winmm_mmioRenameA:
    mov rax, qword ptr [rip + glass_proxy_targets + 1112]
    test rax, rax
    jz proxy_winmm_mmioRenameA_resolve
    jmp rax
proxy_winmm_mmioRenameA_resolve:
    mov r11d, 139
    jmp proxy_resolve_common
.globl proxy_winmm_mmioRenameW
proxy_winmm_mmioRenameW:
    mov rax, qword ptr [rip + glass_proxy_targets + 1120]
    test rax, rax
    jz proxy_winmm_mmioRenameW_resolve
    jmp rax
proxy_winmm_mmioRenameW_resolve:
    mov r11d, 140
    jmp proxy_resolve_common
.globl proxy_winmm_mmioSeek
proxy_winmm_mmioSeek:
    mov rax, qword ptr [rip + glass_proxy_targets + 1128]
    test rax, rax
    jz proxy_winmm_mmioSeek_resolve
    jmp rax
proxy_winmm_mmioSeek_resolve:
    mov r11d, 141
    jmp proxy_resolve_common
.globl proxy_winmm_mmioSendMessage
proxy_winmm_mmioSendMessage:
    mov rax, qword ptr [rip + glass_proxy_targets + 1136]
    test rax, rax
    jz proxy_winmm_mmioSendMessage_resolve
    jmp rax
proxy_winmm_mmioSendMessage_resolve:
    mov r11d, 142
    jmp proxy_resolve_common
.globl proxy_winmm_mmioSetBuffer
proxy_winmm_mmioSetBuffer:
    mov rax, qword ptr [rip + glass_proxy_targets + 1144]
    test rax, rax
    jz proxy_winmm_mmioSetBuffer_resolve
    jmp rax
proxy_winmm_mmioSetBuffer_resolve:
    mov r11d, 143
    jmp proxy_resolve_common
.globl proxy_winmm_mmioSetInfo
proxy_winmm_mmioSetInfo:
    mov rax, qword ptr [rip + glass_proxy_targets + 1152]
    test rax, rax
    jz proxy_winmm_mmioSetInfo_resolve
    jmp rax
proxy_winmm_mmioSetInfo_resolve:
    mov r11d, 144
    jmp proxy_resolve_common
.globl proxy_winmm_mmioStringToFOURCCA
proxy_winmm_mmioStringToFOURCCA:
    mov rax, qword ptr [rip + glass_proxy_targets + 1160]
    test rax, rax
    jz proxy_winmm_mmioStringToFOURCCA_resolve
    jmp rax
proxy_winmm_mmioStringToFOURCCA_resolve:
    mov r11d, 145
    jmp proxy_resolve_common
.globl proxy_winmm_mmioStringToFOURCCW
proxy_winmm_mmioStringToFOURCCW:
    mov rax, qword ptr [rip + glass_proxy_targets + 1168]
    test rax, rax
    jz proxy_winmm_mmioStringToFOURCCW_resolve
    jmp rax
proxy_winmm_mmioStringToFOURCCW_resolve:
    mov r11d, 146
    jmp proxy_resolve_common
.globl proxy_winmm_mmioWrite
proxy_winmm_mmioWrite:
    mov rax, qword ptr [rip + glass_proxy_targets + 1176]
    test rax, rax
    jz proxy_winmm_mmioWrite_resolve
    jmp rax
proxy_winmm_mmioWrite_resolve:
    mov r11d, 147
    jmp proxy_resolve_common
.globl proxy_winmm_mmsystemGetVersion
proxy_winmm_mmsystemGetVersion:
    mov rax, qword ptr [rip + glass_proxy_targets + 1184]
    test rax, rax
    jz proxy_winmm_mmsystemGetVersion_resolve
    jmp rax
proxy_winmm_mmsystemGetVersion_resolve:
    mov r11d, 148
    jmp proxy_resolve_common
.globl proxy_winmm_sndPlaySoundA
proxy_winmm_sndPlaySoundA:
    mov rax, qword ptr [rip + glass_proxy_targets + 1192]
    test rax, rax
    jz proxy_winmm_sndPlaySoundA_resolve
    jmp rax
proxy_winmm_sndPlaySoundA_resolve:
    mov r11d, 149
    jmp proxy_resolve_common
.globl proxy_winmm_sndPlaySoundW
proxy_winmm_sndPlaySoundW:
    mov rax, qword ptr [rip + glass_proxy_targets + 1200]
    test rax, rax
    jz proxy_winmm_sndPlaySoundW_resolve
    jmp rax
proxy_winmm_sndPlaySoundW_resolve:
    mov r11d, 150
    jmp proxy_resolve_common
.globl proxy_winmm_timeBeginPeriod
proxy_winmm_timeBeginPeriod:
    mov rax, qword ptr [rip + glass_proxy_targets + 1208]
    test rax, rax
    jz proxy_winmm_timeBeginPeriod_resolve
    jmp rax
proxy_winmm_timeBeginPeriod_resolve:
    mov r11d, 151
    jmp proxy_resolve_common
.globl proxy_winmm_timeEndPeriod
proxy_winmm_timeEndPeriod:
    mov rax, qword ptr [rip + glass_proxy_targets + 1216]
    test rax, rax
    jz proxy_winmm_timeEndPeriod_resolve
    jmp rax
proxy_winmm_timeEndPeriod_resolve:
    mov r11d, 152
    jmp proxy_resolve_common
.globl proxy_winmm_timeGetDevCaps
proxy_winmm_timeGetDevCaps:
    mov rax, qword ptr [rip + glass_proxy_targets + 1224]
    test rax, rax
    jz proxy_winmm_timeGetDevCaps_resolve
    jmp rax
proxy_winmm_timeGetDevCaps_resolve:
    mov r11d, 153
    jmp proxy_resolve_common
.globl proxy_winmm_timeGetSystemTime
proxy_winmm_timeGetSystemTime:
    mov rax, qword ptr [rip + glass_proxy_targets + 1232]
    test rax, rax
    jz proxy_winmm_timeGetSystemTime_resolve
    jmp rax
proxy_winmm_timeGetSystemTime_resolve:
    mov r11d, 154
    jmp proxy_resolve_common
.globl proxy_winmm_timeGetTime
proxy_winmm_timeGetTime:
    mov rax, qword ptr [rip + glass_proxy_targets + 1240]
    test rax, rax
    jz proxy_winmm_timeGetTime_resolve
    jmp rax
proxy_winmm_timeGetTime_resolve:
    mov r11d, 155
    jmp proxy_resolve_common
.globl proxy_winmm_timeKillEvent
proxy_winmm_timeKillEvent:
    mov rax, qword ptr [rip + glass_proxy_targets + 1248]
    test rax, rax
    jz proxy_winmm_timeKillEvent_resolve
    jmp rax
proxy_winmm_timeKillEvent_resolve:
    mov r11d, 156
    jmp proxy_resolve_common
.globl proxy_winmm_timeSetEvent
proxy_winmm_timeSetEvent:
    mov rax, qword ptr [rip + glass_proxy_targets + 1256]
    test rax, rax
    jz proxy_winmm_timeSetEvent_resolve
    jmp rax
proxy_winmm_timeSetEvent_resolve:
    mov r11d, 157
    jmp proxy_resolve_common
.globl proxy_winmm_waveInAddBuffer
proxy_winmm_waveInAddBuffer:
    mov rax, qword ptr [rip + glass_proxy_targets + 1264]
    test rax, rax
    jz proxy_winmm_waveInAddBuffer_resolve
    jmp rax
proxy_winmm_waveInAddBuffer_resolve:
    mov r11d, 158
    jmp proxy_resolve_common
.globl proxy_winmm_waveInClose
proxy_winmm_waveInClose:
    mov rax, qword ptr [rip + glass_proxy_targets + 1272]
    test rax, rax
    jz proxy_winmm_waveInClose_resolve
    jmp rax
proxy_winmm_waveInClose_resolve:
    mov r11d, 159
    jmp proxy_resolve_common
.globl proxy_winmm_waveInGetDevCapsA
proxy_winmm_waveInGetDevCapsA:
    mov rax, qword ptr [rip + glass_proxy_targets + 1280]
    test rax, rax
    jz proxy_winmm_waveInGetDevCapsA_resolve
    jmp rax
proxy_winmm_waveInGetDevCapsA_resolve:
    mov r11d, 160
    jmp proxy_resolve_common
.globl proxy_winmm_waveInGetDevCapsW
proxy_winmm_waveInGetDevCapsW:
    mov rax, qword ptr [rip + glass_proxy_targets + 1288]
    test rax, rax
    jz proxy_winmm_waveInGetDevCapsW_resolve
    jmp rax
proxy_winmm_waveInGetDevCapsW_resolve:
    mov r11d, 161
    jmp proxy_resolve_common
.globl proxy_winmm_waveInGetErrorTextA
proxy_winmm_waveInGetErrorTextA:
    mov rax, qword ptr [rip + glass_proxy_targets + 1296]
    test rax, rax
    jz proxy_winmm_waveInGetErrorTextA_resolve
    jmp rax
proxy_winmm_waveInGetErrorTextA_resolve:
    mov r11d, 162
    jmp proxy_resolve_common
.globl proxy_winmm_waveInGetErrorTextW
proxy_winmm_waveInGetErrorTextW:
    mov rax, qword ptr [rip + glass_proxy_targets + 1304]
    test rax, rax
    jz proxy_winmm_waveInGetErrorTextW_resolve
    jmp rax
proxy_winmm_waveInGetErrorTextW_resolve:
    mov r11d, 163
    jmp proxy_resolve_common
.globl proxy_winmm_waveInGetID
proxy_winmm_waveInGetID:
    mov rax, qword ptr [rip + glass_proxy_targets + 1312]
    test rax, rax
    jz proxy_winmm_waveInGetID_resolve
    jmp rax
proxy_winmm_waveInGetID_resolve:
    mov r11d, 164
    jmp proxy_resolve_common
.globl proxy_winmm_waveInGetNumDevs
proxy_winmm_waveInGetNumDevs:
    mov rax, qword ptr [rip + glass_proxy_targets + 1320]
    test rax, rax
    jz proxy_winmm_waveInGetNumDevs_resolve
    jmp rax
proxy_winmm_waveInGetNumDevs_resolve:
    mov r11d, 165
    jmp proxy_resolve_common
.globl proxy_winmm_waveInGetPosition
proxy_winmm_waveInGetPosition:
    mov rax, qword ptr [rip + glass_proxy_targets + 1328]
    test rax, rax
    jz proxy_winmm_waveInGetPosition_resolve
    jmp rax
proxy_winmm_waveInGetPosition_resolve:
    mov r11d, 166
    jmp proxy_resolve_common
.globl proxy_winmm_waveInMessage
proxy_winmm_waveInMessage:
    mov rax, qword ptr [rip + glass_proxy_targets + 1336]
    test rax, rax
    jz proxy_winmm_waveInMessage_resolve
    jmp rax
proxy_winmm_waveInMessage_resolve:
    mov r11d, 167
    jmp proxy_resolve_common
.globl proxy_winmm_waveInOpen
proxy_winmm_waveInOpen:
    mov rax, qword ptr [rip + glass_proxy_targets + 1344]
    test rax, rax
    jz proxy_winmm_waveInOpen_resolve
    jmp rax
proxy_winmm_waveInOpen_resolve:
    mov r11d, 168
    jmp proxy_resolve_common
.globl proxy_winmm_waveInPrepareHeader
proxy_winmm_waveInPrepareHeader:
    mov rax, qword ptr [rip + glass_proxy_targets + 1352]
    test rax, rax
    jz proxy_winmm_waveInPrepareHeader_resolve
    jmp rax
proxy_winmm_waveInPrepareHeader_resolve:
    mov r11d, 169
    jmp proxy_resolve_common
.globl proxy_winmm_waveInReset
proxy_winmm_waveInReset:
    mov rax, qword ptr [rip + glass_proxy_targets + 1360]
    test rax, rax
    jz proxy_winmm_waveInReset_resolve
    jmp rax
proxy_winmm_waveInReset_resolve:
    mov r11d, 170
    jmp proxy_resolve_common
.globl proxy_winmm_waveInStart
proxy_winmm_waveInStart:
    mov rax, qword ptr [rip + glass_proxy_targets + 1368]
    test rax, rax
    jz proxy_winmm_waveInStart_resolve
    jmp rax
proxy_winmm_waveInStart_resolve:
    mov r11d, 171
    jmp proxy_resolve_common
.globl proxy_winmm_waveInStop
proxy_winmm_waveInStop:
    mov rax, qword ptr [rip + glass_proxy_targets + 1376]
    test rax, rax
    jz proxy_winmm_waveInStop_resolve
    jmp rax
proxy_winmm_waveInStop_resolve:
    mov r11d, 172
    jmp proxy_resolve_common
.globl proxy_winmm_waveInUnprepareHeader
proxy_winmm_waveInUnprepareHeader:
    mov rax, qword ptr [rip + glass_proxy_targets + 1384]
    test rax, rax
    jz proxy_winmm_waveInUnprepareHeader_resolve
    jmp rax
proxy_winmm_waveInUnprepareHeader_resolve:
    mov r11d, 173
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutBreakLoop
proxy_winmm_waveOutBreakLoop:
    mov rax, qword ptr [rip + glass_proxy_targets + 1392]
    test rax, rax
    jz proxy_winmm_waveOutBreakLoop_resolve
    jmp rax
proxy_winmm_waveOutBreakLoop_resolve:
    mov r11d, 174
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutClose
proxy_winmm_waveOutClose:
    mov rax, qword ptr [rip + glass_proxy_targets + 1400]
    test rax, rax
    jz proxy_winmm_waveOutClose_resolve
    jmp rax
proxy_winmm_waveOutClose_resolve:
    mov r11d, 175
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutGetDevCapsA
proxy_winmm_waveOutGetDevCapsA:
    mov rax, qword ptr [rip + glass_proxy_targets + 1408]
    test rax, rax
    jz proxy_winmm_waveOutGetDevCapsA_resolve
    jmp rax
proxy_winmm_waveOutGetDevCapsA_resolve:
    mov r11d, 176
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutGetDevCapsW
proxy_winmm_waveOutGetDevCapsW:
    mov rax, qword ptr [rip + glass_proxy_targets + 1416]
    test rax, rax
    jz proxy_winmm_waveOutGetDevCapsW_resolve
    jmp rax
proxy_winmm_waveOutGetDevCapsW_resolve:
    mov r11d, 177
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutGetErrorTextA
proxy_winmm_waveOutGetErrorTextA:
    mov rax, qword ptr [rip + glass_proxy_targets + 1424]
    test rax, rax
    jz proxy_winmm_waveOutGetErrorTextA_resolve
    jmp rax
proxy_winmm_waveOutGetErrorTextA_resolve:
    mov r11d, 178
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutGetErrorTextW
proxy_winmm_waveOutGetErrorTextW:
    mov rax, qword ptr [rip + glass_proxy_targets + 1432]
    test rax, rax
    jz proxy_winmm_waveOutGetErrorTextW_resolve
    jmp rax
proxy_winmm_waveOutGetErrorTextW_resolve:
    mov r11d, 179
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutGetID
proxy_winmm_waveOutGetID:
    mov rax, qword ptr [rip + glass_proxy_targets + 1440]
    test rax, rax
    jz proxy_winmm_waveOutGetID_resolve
    jmp rax
proxy_winmm_waveOutGetID_resolve:
    mov r11d, 180
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutGetNumDevs
proxy_winmm_waveOutGetNumDevs:
    mov rax, qword ptr [rip + glass_proxy_targets + 1448]
    test rax, rax
    jz proxy_winmm_waveOutGetNumDevs_resolve
    jmp rax
proxy_winmm_waveOutGetNumDevs_resolve:
    mov r11d, 181
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutGetPitch
proxy_winmm_waveOutGetPitch:
    mov rax, qword ptr [rip + glass_proxy_targets + 1456]
    test rax, rax
    jz proxy_winmm_waveOutGetPitch_resolve
    jmp rax
proxy_winmm_waveOutGetPitch_resolve:
    mov r11d, 182
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutGetPlaybackRate
proxy_winmm_waveOutGetPlaybackRate:
    mov rax, qword ptr [rip + glass_proxy_targets + 1464]
    test rax, rax
    jz proxy_winmm_waveOutGetPlaybackRate_resolve
    jmp rax
proxy_winmm_waveOutGetPlaybackRate_resolve:
    mov r11d, 183
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutGetPosition
proxy_winmm_waveOutGetPosition:
    mov rax, qword ptr [rip + glass_proxy_targets + 1472]
    test rax, rax
    jz proxy_winmm_waveOutGetPosition_resolve
    jmp rax
proxy_winmm_waveOutGetPosition_resolve:
    mov r11d, 184
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutGetVolume
proxy_winmm_waveOutGetVolume:
    mov rax, qword ptr [rip + glass_proxy_targets + 1480]
    test rax, rax
    jz proxy_winmm_waveOutGetVolume_resolve
    jmp rax
proxy_winmm_waveOutGetVolume_resolve:
    mov r11d, 185
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutMessage
proxy_winmm_waveOutMessage:
    mov rax, qword ptr [rip + glass_proxy_targets + 1488]
    test rax, rax
    jz proxy_winmm_waveOutMessage_resolve
    jmp rax
proxy_winmm_waveOutMessage_resolve:
    mov r11d, 186
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutOpen
proxy_winmm_waveOutOpen:
    mov rax, qword ptr [rip + glass_proxy_targets + 1496]
    test rax, rax
    jz proxy_winmm_waveOutOpen_resolve
    jmp rax
proxy_winmm_waveOutOpen_resolve:
    mov r11d, 187
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutPause
proxy_winmm_waveOutPause:
    mov rax, qword ptr [rip + glass_proxy_targets + 1504]
    test rax, rax
    jz proxy_winmm_waveOutPause_resolve
    jmp rax
proxy_winmm_waveOutPause_resolve:
    mov r11d, 188
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutPrepareHeader
proxy_winmm_waveOutPrepareHeader:
    mov rax, qword ptr [rip + glass_proxy_targets + 1512]
    test rax, rax
    jz proxy_winmm_waveOutPrepareHeader_resolve
    jmp rax
proxy_winmm_waveOutPrepareHeader_resolve:
    mov r11d, 189
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutReset
proxy_winmm_waveOutReset:
    mov rax, qword ptr [rip + glass_proxy_targets + 1520]
    test rax, rax
    jz proxy_winmm_waveOutReset_resolve
    jmp rax
proxy_winmm_waveOutReset_resolve:
    mov r11d, 190
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutRestart
proxy_winmm_waveOutRestart:
    mov rax, qword ptr [rip + glass_proxy_targets + 1528]
    test rax, rax
    jz proxy_winmm_waveOutRestart_resolve
    jmp rax
proxy_winmm_waveOutRestart_resolve:
    mov r11d, 191
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutSetPitch
proxy_winmm_waveOutSetPitch:
    mov rax, qword ptr [rip + glass_proxy_targets + 1536]
    test rax, rax
    jz proxy_winmm_waveOutSetPitch_resolve
    jmp rax
proxy_winmm_waveOutSetPitch_resolve:
    mov r11d, 192
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutSetPlaybackRate
proxy_winmm_waveOutSetPlaybackRate:
    mov rax, qword ptr [rip + glass_proxy_targets + 1544]
    test rax, rax
    jz proxy_winmm_waveOutSetPlaybackRate_resolve
    jmp rax
proxy_winmm_waveOutSetPlaybackRate_resolve:
    mov r11d, 193
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutSetVolume
proxy_winmm_waveOutSetVolume:
    mov rax, qword ptr [rip + glass_proxy_targets + 1552]
    test rax, rax
    jz proxy_winmm_waveOutSetVolume_resolve
    jmp rax
proxy_winmm_waveOutSetVolume_resolve:
    mov r11d, 194
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutUnprepareHeader
proxy_winmm_waveOutUnprepareHeader:
    mov rax, qword ptr [rip + glass_proxy_targets + 1560]
    test rax, rax
    jz proxy_winmm_waveOutUnprepareHeader_resolve
    jmp rax
proxy_winmm_waveOutUnprepareHeader_resolve:
    mov r11d, 195
    jmp proxy_resolve_common
.globl proxy_winmm_waveOutWrite
proxy_winmm_waveOutWrite:
    mov rax, qword ptr [rip + glass_proxy_targets + 1568]
    test rax, rax
    jz proxy_winmm_waveOutWrite_resolve
    jmp rax
proxy_winmm_waveOutWrite_resolve:
    mov r11d, 196
    jmp proxy_resolve_common
.globl proxy_winmm_ordinal2
proxy_winmm_ordinal2:
    mov rax, qword ptr [rip + glass_proxy_targets + 1576]
    test rax, rax
    jz proxy_winmm_ordinal2_resolve
    jmp rax
proxy_winmm_ordinal2_resolve:
    mov r11d, 197
    jmp proxy_resolve_common
