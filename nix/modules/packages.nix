{pkgs, ...}: {
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
    fzf
    fd
    zoxide
    yazi
    skim
    newsboat
    bat
    lazygit
    eza
    ghostscript
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];
}
