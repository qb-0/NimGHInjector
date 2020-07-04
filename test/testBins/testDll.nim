when not defined(cpu64):
  {.passL: "-s -static-libgcc".}

when isMainModule:
  echo "DLL INJECTED!"