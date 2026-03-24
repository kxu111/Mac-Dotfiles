{self, ...}: {
  system = {
    # change keymaps
    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;
    # key repeat
    defaults.NSGlobalDomain.KeyRepeat = 2;
    defaults.NSGlobalDomain.InitialKeyRepeat = 15;

    # trackpad settings
    defaults.".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;
    defaults.NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
  };
}
