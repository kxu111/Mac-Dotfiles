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
  ];

  services.yabai.enable = true;
  services.skhd.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    maple-mono.NF-unhinted
  ];
}
