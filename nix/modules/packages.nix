{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    bob-nvim
    tmux
    btop
    fastfetch
    alacritty
    stow
    ripgrep
    cargo
    nodePackages.npm
    tealdeer
    lsd
    alejandra
  ];

  services.yabai.enable = true;
  services.skhd.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
  ];
}
