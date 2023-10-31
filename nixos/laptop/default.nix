{ lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  environment.systemPackages = with pkgs; [];

  hardware.pulseaudio.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" ];
    packages = with pkgs; [
      firefox
      neovim
      thunderbird
      tidal-hifi
      xfce.xfce4-volumed-pulse
    ];
  };

  sound.enable = true;
  sound.mediaKeys.enable = true;
}
