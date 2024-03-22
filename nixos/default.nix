{ nixpkgs, nixos-hardware, ... }:

let
  system = "x86_64-linux";
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
  # helen (NAS)
  helen = lib.nixosSystem {
    inherit system;
    modules = [
      ./configuration.nix
      ./helen
    ];
  };
}
