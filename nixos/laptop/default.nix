{ lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."luks-3a11ecc8-e8b3-481b-aae7-25ed29aabe3b".device = "/dev/disk/by-uuid/3a11ecc8-e8b3-481b-aae7-25ed29aabe3b";
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk = true;


  boot.initrd.luks.devices."luks-6f6be88f-617d-4653-9f12-af4619d9c07c".keyFile = "/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-3a11ecc8-e8b3-481b-aae7-25ed29aabe3b".keyFile = "/crypto_keyfile.bin";

  environment.systemPackages = with pkgs; [];

  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver = {
    layout = "eu";
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    displayManager.defaultSession = "xfce+i3";
    windowManager.i3.enable = true;
  };
  services.getty.autologinUser = "pascal";

  users.users.pascal = {
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      neovim
      firefox
    ];
  };
}
