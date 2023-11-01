{ lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelParams = [ "mem_sleep_default=deep" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };


  environment.systemPackages = with pkgs; [ ];

  hardware.pulseaudio.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices."luks-6ab21dc8-6040-4a8f-adfd-df00ead54cd0".device = "/dev/disk/by-uuid/6ab21dc8-6040-4a8f-adfd-df00ead54cd0";
  networking.hostName = "ruth"; # Define your hostname.

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
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
  };
  services.getty.autologinUser = "pascal";
  services.power-profiles-daemon.enable = lib.mkDefault true;
  services.fprintd.enable = lib.mkDefault true;

  users.users.pascal = {
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" ];
    packages = with pkgs; [
      firefox
      neovim
      signal-desktop
      thunderbird
      tidal-hifi
      xfce.xfce4-volumed-pulse
    ];
  };

  sound.enable = true;
  sound.mediaKeys.enable = true;
}
