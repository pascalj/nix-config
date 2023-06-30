{
  description = "NixOS and Home Manager Configurations";


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      user = "pascal";
      location = "$HOME/.nix-config";
    in
    {
      nixosConfigurations = (
        import ./nixos {
          inherit (nixpkgs) lib;
          inherit nixpkgs home-manager;
        }
      );
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
