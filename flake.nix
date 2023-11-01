{
  description = "NixOS and Home Manager Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      user = "pascal";
      location = "$HOME/.nix-config";
      # 'home-manager switch' will look for <username>@<host> and <username>
      hosts = [
        { username = "pascal"; hostname = "ruth"; }
        { username = "pascalj"; hostname = "carol"; }
        { username = "pascal"; hostname = "GS-3KXV8Y3"; }
      ];

      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      # Small wrapper to have a ./<hostname>.nix file
      mkHome = { username, hostname }: {
        "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = (builtins.filter builtins.pathExists [
            ./home
            ./home/${hostname}.nix
          ]) ++ [
            {
              home.username = username;
              home.homeDirectory = "/home/${username}";
            }
          ];
        };

      };
    in
    {
      nixosConfigurations = (
        import ./nixos {
          inherit (nixpkgs) lib;
          inherit nixpkgs home-manager;
        }
      );
      homeConfigurations = pkgs.lib.attrsets.mergeAttrsList (map mkHome hosts);
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
    };
}
