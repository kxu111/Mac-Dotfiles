{
  description = "Custom Iosevka font build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        iosevka-custom = pkgs.iosevka.override {
          set = "Custom";
          privateBuildPlan = builtins.readFile ./build-plan.toml;
        };
      in
      {
        packages = {
          default = iosevka-custom;
          iosevka-custom = iosevka-custom;
        };
      }
    );
}
