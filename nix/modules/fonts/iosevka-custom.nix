{
  description = "My custom Iosevka build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        packages = {
          iosevka-custom = pkgs.iosevka.override {
            set = "Iosevka Custom";
            privateBuildPlan = builtins.readFile ./build-plan.toml;
          };
          default = self.packages.${system}.my-iosevka;
        };
      }
    );
}
