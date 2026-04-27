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
    zoxide
    yazi
    fd
    skim
    newsboat
    bat
    lazygit
    eza
    ghostscript
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    maple-mono.NF
    kirsch
    nerd-fonts.geist-mono
  ];
}
