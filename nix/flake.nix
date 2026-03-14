{
  description = "kenny nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    nix-homebrew,
  }: {
    darwinConfigurations."kennys-MacBook-Air" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit self;};
      modules = [
        ./modules/packages.nix
        ./modules/homebrew.nix
        ./modules/system.nix
        ./modules/settings.nix
        ./modules/input.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "kenny";
          };
        }
      ];
    };
  };
}
