#[
  Wrapper for the GuidedHacking.com DLL Injector Library
  Credits to Broihon for the cpp library.
  https://guidedhacking.com/resources/guided-hacking-dll-injector.4/
]#

when defined(cpu64):
  const ghInjLib* = "GH Injector - x64.dll"
  {.passL: "-static-libgcc -static-libstdc++".}
else:
  const ghInjLib* = "GH Injector - x86.dll"

const 
  MAX_PATH* = 260

const
  # Injection Flags
  INJ_ERASE_HEADER* = 0x00000001
  INJ_FAKE_HEADER* = 0x00000002
  INJ_UNLINK_FROM_PEB* = 0x00000004
  INJ_SHIFT_MODULE* = 0x00000008
  INJ_CLEAN_DATA_DIR* = 0x00000010
  INJ_THREAD_CREATE_CLOAKED* = 0x00000020
  INJ_SCRAMBLE_DLL_NAME* = 0x00000040
  INJ_LOAD_DLL_COPY* = 0x00000080
  INJ_HIJACK_HANDLE* = 0x00000100
  INJ_MAX_FLAGS* = 0x000001FF

type
  INJECTION_MODE* = enum
    IM_LoadLibrary, IM_LdrLoadDll, IM_ManualMap

  LAUNCH_METHOD* = enum
    LM_NtCreateThreadEx,
    LM_HijackThread,
    LM_SetWindowsHookEx,
    LM_QueueUserAPC,
    LM_SetWindowLong

  INJECTIONDATAA* {.bycopy.} = object
    LastErrorCode*: cint                     ## used to store the error code of the injection
    szDllPath*: array[MAX_PATH * 2, char]    ## fullpath to the dll to inject
    ProcessID*: cint                         ## process identifier of the target process
    Mode*: INJECTION_MODE                    ## injection mode
    Method*: LAUNCH_METHOD                   ## method to execute the remote shellcode
    Flags*: cint                             ## combination of the flags defined above
    hHandleValue*: cint                      ## optional value to identify a handle in a process
    hDllOut*: cint                           ## returned image base of the injection

  INJECTIONDATAW* {.bycopy.} = object
    LastErrorCode*: int32
    szDllPath*: array[MAX_PATH * 2, char]
    szTargetProcessExeFileName*: ptr cstring ## exe name of the target process, this value gets set automatically and should be ignored
    ProcessID*: cint
    Mode*: INJECTION_MODE
    Method*: LAUNCH_METHOD
    Flags*: cint
    hHandleValue*: int32
    hDllOut*: cint

proc InjectA*(pData: ptr INJECTIONDATAA): cint {.stdcall, importc, discardable, dynlib: ghInjLib.}
proc InjectW*(pData: ptr INJECTIONDATAW): cint {.stdcall, importc, discardable, dynlib: ghInjLib.}

