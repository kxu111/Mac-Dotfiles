{...}: {
  homebrew = {
    enable = true;
    global.autoUpdate = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    brews = [
      "mas"
      "node"
      "mole"
      "zsh-syntax-highlighting"
      "pkgconfig"
      "raylib"
      "yt-dlp"
      "uv"
    ];
    casks = [
      "vesktop"
      "steam"
      "helium-browser"
      "sioyek"
      "obs"
      "vlc"
      "ghostty"
      "desktoppr"
      "karabiner-elements"
      "aerospace"
      "anki"
      "raycast"
    ];
    masApps = {
      "Davinci Resolve" = 571213070;
      "WhatsApp" = 310633997;
    };
  };
}
