{ lib, nixpkgs, home-manager, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  # Server
  annie = lib.nixosSystem {
    inherit system;
    modules = [
      ./configuration.nix
      ./annie

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.pascal = {
          imports = [
            (import ./home.nix)
          ];
        };
      }
    ];
  };
}
