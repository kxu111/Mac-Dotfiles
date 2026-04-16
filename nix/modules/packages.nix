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
    lsd
    tealdeer
    unzip
    python3
    fzf
	zoxide
	yazi
	fd
	skim
  ];

  services.yabai.enable = true;
  services.skhd.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
	nerd-fonts.jetbrains-mono
    maple-mono.NF
  ];
}
