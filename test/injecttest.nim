import os, osproc
import ../src/nimghinjector

proc injectDLL =
  let testProcess = startProcess("testBins/testApp.exe", options={ProcessOption.poParentStreams})
  sleep(500)

  var injData = injectionData(
    szDllPath: dllPath("testBins/testLib.dll"),
    ProcessID: testProcess.processID().cint,
    Mode: injectionMode.IM_LdrLoadDll,
    Method: lunchMethod.LM_NtCreateThreadEx,
    Timeout: 3000,
  )

  let injResult = Inject(injData.addr).errName()
  echo "Injection result: ", injResult
  
  sleep(500)
  testProcess.terminate()

when isMainModule:
  injectDLL()
  sleep(2500)