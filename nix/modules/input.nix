{ self, ... }: {

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
  system.NSGlobalDomain = {
    KeyRepeat = 2;
    InitialKeyRepeat = 15;
  }

}

