{ lib, nixpkgs, ... }:

{
  imports = [ (import ./hardware-configuration.nix) ];

  services = { };
  virtualisation.docker.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "annie";

  services.openssh.enable = true;

  programs.mosh.enable = true;
}
