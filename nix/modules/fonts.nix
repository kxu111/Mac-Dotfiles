({
  pkgs,
  aporetic-nerd-font,
  ...
}: {
  environment.systemPackages = [
    aporetic-nerd-font.packages.${pkgs.system}.default
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    aporetic
    nerd-fonts.jetbrains-mono
  ];
})
