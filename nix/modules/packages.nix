{ pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ 
    neovim
    btop
    fastfetch
    alacritty
    stow
    yabai
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  homebrew = {
    enable = true;
    global.autoUpdate = true;
    onActivation = { cleanup = "zap"; autoUpdate = true; upgrade = true; };
    brews = [ "mas" ];
    casks = [
      "librewolf"
      "vesktop"
      "steam"
      "the-unarchiver"
    ];
    masApps = {
      "Davinci Resolve" = 571213070;
      "WhatsApp" = 310633997;
    };
  };

}
