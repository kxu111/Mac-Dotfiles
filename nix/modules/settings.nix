{
  self,
  inputs,
  ...
}: {
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
        "/Applications/Ghostty.app"
        "/Applications/Helium.app"
        "/Applications/Vesktop.app"
        "/Applications/Spotify.app/"
        "/Applications/Steam.app/"
        "/Applications/WhatsApp.app"
        "/Applications/OBS.app"
        "/Applications/DaVinci Resolve.app"
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

  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
