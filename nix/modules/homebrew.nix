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
    ];
    casks = [
      "librewolf"
      "vesktop"
      "steam"
      "helium-browser"
      "sioyek"
      "obs"
      "vlc"
      "raycast"
      "ghostty"
	  "alacritty"
    ];
    masApps = {
      "Davinci Resolve" = 571213070;
      "WhatsApp" = 310633997;
    };
  };
}
