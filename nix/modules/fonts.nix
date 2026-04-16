({
  config,
  pkgs,
  lib,
  aporetic-nerd-font,
  ...
}: {
  fonts.packages = [
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.jetbrains-mono
    aporetic-nerd-font.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
})
