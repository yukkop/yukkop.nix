final: prev: {
    lib = prev.lib.recursiveUpdate prev.lib {
      licenses.unfreeRedistributableFirmware = 
        prev.lib.licenses.unfreeRedistributableFirmware // { free = false; };
      };
}
