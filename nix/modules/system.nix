{ self, ... }: {

  system = {
    primaryUser = "kenny";

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    defaults = {
      dock = {
        autohide = true; 
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        orientation = "left";
        show-recents = false;
        minimize-to-application = true;
        persistent-apps = [
          "/Applications/Librewolf.app"
          "/Applications/Vesktop.app"
  	  "/Applications/WhatsApp.app"
        ];
        mru-spaces = false;
      };
      finder = {
        FXPreferredViewStyle = "clmv";
        ShowPathbar = true;
        AppleShowAllFiles = true;
        NewWindowTarget = "Documents";
        QuitMenuItem = true;
      };
      loginwindow.GuestEnabled = false;
      controlcenter.BatteryShowPercentage = true;
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
      };
    };
  };

    nix.settings.experimental-features = "nix-command flakes";
    system.configurationRevision = self.rev or self.dirtyRev or null;
    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";

}

