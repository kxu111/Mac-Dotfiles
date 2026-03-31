{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    fastfetch
    btop
    alacritty
    stow
    vim
    bob-nvim
    cargo
    nodePackages.npm
    ripgrep
    tmux
    lsd
    tealdeer
    unzip
  ];

  services.yabai.enable = true;
  services.skhd.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    maple-mono.NF
  ];
}
