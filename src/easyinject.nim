from os import fileExists
import tables

import wAuto/process
import nimghinjector
import errors

static:
  if not fileExists(ghInjLib):
    {.warning: "Missing " & ghInjLib & "! Download the latest release at GuidedHacking.com".}

proc dllpath*(path: cstring): array[MAX_PATH * 2, char] = copyMem(result.addr, path, path.len + 1)
proc orArgs(v: varargs[int]): int32 =
  for i in v: result = result or i.int32

proc Inject*(pid: int32, path: cstring, injMode: INJECTION_MODE, injMethod: LAUNCH_METHOD,
    flags: varargs[int]): tuple[result: string, data: INJECTIONDATAA] =
  var iD = INJECTIONDATAA(
    ProcessID: pid,
    szDllPath: dllpath path,
    Mode: injMode,
    Method: injMethod,
    Flags: flags.orArgs
  )
  result = (errorCode[InjectA(iD.addr)], iD)

proc Inject*(process: string, path: cstring, injMode: INJECTION_MODE, injMethod: LAUNCH_METHOD,
    flags: varargs[int]): tuple[result: string, data: INJECTIONDATAA] =
  for p in processes():
    if p[0] == process:
      return Inject(p[1].int32, path, injMode, injMethod, flags)
  raise newException(ValueError, "Process not found")
