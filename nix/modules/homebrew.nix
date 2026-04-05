{...}: {
  homebrew = {
    enable = true;
    global.autoUpdate = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    brews = ["mas"];
    casks = [
      "librewolf"
      "vesktop"
      "steam"
      "ungoogled-chromium"
      "sioyek"
      "obs"
      "vlc"
      "raycast"
      "karabiner-elements"
    ];
    masApps = {
      "Davinci Resolve" = 571213070;
      "WhatsApp" = 310633997;
    };
  };
}
