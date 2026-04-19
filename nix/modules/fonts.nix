({
  pkgs,
  aporetic-nerd-font,
  ...
}: {
  fonts.packages = [
    pkgs.nerd-fonts.iosevka
    aporetic-nerd-font.packages.${pkgs.stdenv.hostPlatform.system}.default
	pkgs.maple-mono.NF
  ];
})
