{ self, nixpkgs, nixos-hardware, ... }:

let
  system = "x86_64-linux";
  lib = nixpkgs.lib;
  autoUpdate = ({ system, ... }: {
    system.autoUpgrade = {
      enable = true;
      flake = self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L"
      ];
      dates = "daily";
    };
  });
in
{
  # Server
  annie = lib.nixosSystem {
    inherit system;
    modules = [
      ./configuration.nix
      ./annie
      autoUpdate
    ];
  };
  # Laptop
  ruth = lib.nixosSystem {
    inherit system;
    modules = [
      nixos-hardware.nixosModules.framework-13-7040-amd
      ./configuration.nix
      ./ruth
      autoUpdate
    ];
  };
}
