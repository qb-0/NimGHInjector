import os
import osproc
import nimghinjector, easyinject

proc injectDLL =
  let testProc = startProcess("testBins/testApp.exe", options={ProcessOption.poParentStreams})
  sleep(500)

  echo Inject("testApp.exe", "testBins/testDLL.dll", INJECTION_MODE.IM_LoadLibrary, LAUNCH_METHOD.LM_NtCreateThreadEx).result
  sleep(500)

  testProc.terminate()

when isMainModule:
  injectDLL()
  sleep(2500)