{pkgs, iosevka-custom, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    fastfetch
    btop
    stow
    vim
    bob-nvim
    ripgrep
    rustup
    tmux
    tree
    tealdeer
    unzip
    python3
    fzf
    zoxide
    yazi
    fd
    skim
    newsboat
    bat
    lazygit
    eza
  ];

  fonts.packages = [
    pkgs.maple-mono.NF
    iosevka-custom.packages.aarch64-darwin.default
  ];

  services.yabai.enable = true;
  services.skhd.enable = true;
}
