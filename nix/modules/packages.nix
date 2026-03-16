{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    btop
    fastfetch
    alacritty
    stow
    ripgrep
    bob-nvim
    cargo
    nodePackages.npm
    tealdeer
    lsd
	sioyek
	sketchybar
  ];

  services.yabai.enable = true;
  services.skhd.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
	nerd-fonts.jetbrains-mono
  ];
}
