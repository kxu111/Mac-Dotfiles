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
      "the-unarchiver"
	  "sioyek"
      "obs"
    ];
    masApps = {
      "Davinci Resolve" = 571213070;
      "WhatsApp" = 310633997;
    };
  };
}
