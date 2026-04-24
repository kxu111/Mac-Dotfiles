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

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    maple-mono.NF
  ];
}
