{ lib, nixpkgs, ... }:

{
  imports = [ (import ./hardware-configuration.nix) ];

  services = { };
  virtualisation.docker.enable = true;
}
