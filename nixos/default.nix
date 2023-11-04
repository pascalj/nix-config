{ lib, nixpkgs, home-manager, nixos-hardware, ... }:

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
    ];
  };
  # Laptop
  ruth = lib.nixosSystem {
    inherit system;
    modules = [
      nixos-hardware.nixosModules.framework-13-7040-amd
      ./configuration.nix
      ./ruth
    ];
  };
}
