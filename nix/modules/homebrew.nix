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
    ];
    casks = [
      "librewolf"
      "vesktop"
      "steam"
      "helium-browser"
      "sioyek"
      "obs"
	  "mpv"
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
