{self, ...}: {
  system.primaryUser = "kenny";
  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      orientation = "right";
      show-recents = false;
      minimize-to-application = true;
      persistent-apps = [
        "/Applications/Librewolf.app"
        "/Applications/Chromium.app"
        "/Applications/Vesktop.app"
        "/Applications/WhatsApp.app"
        "/Applications/sioyek.app"
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
      _HIHideMenuBar = false;
    };
    screencapture.location = "~/Pictures/Screenshots";
  };
}
