{ lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 8;
      systemd-boot.enable = true;
    };
  };


  environment = {
    loginShellInit = ''
      [[ "$(tty)" == /dev/tty1 ]] && sway
    '';
    sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
    systemPackages = with pkgs; [ wayland ];
  };

  # Smooth scrolling in Firefox

  hardware = {
    pulseaudio.enable = true;
    opengl.enable = true;
  };

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices."luks-6ab21dc8-6040-4a8f-adfd-df00ead54cd0".device = "/dev/disk/by-uuid/6ab21dc8-6040-4a8f-adfd-df00ead54cd0";
  networking = {
    hostName = "ruth";
    hosts = {
      "127.0.0.1" = [ "mklocal.localhost" ];
    };
  };

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

  # sway:
  services.dbus.enable = true;
  programs.dconf.enable = true;
  services = {
    getty.autologinUser = "pascal";
    power-profiles-daemon.enable = lib.mkDefault true;
    fprintd.enable = lib.mkDefault true;
  };

  users.users.pascal = {
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "video" ];
    packages = with pkgs; [
      firefox
      neovim
      obsidian
      signal-desktop
      thunderbird
      tidal-hifi
      unzip
      xfce.xfce4-volumed-pulse
      zathura
    ];
  };

  security = {
    pam.services.swaylock = { };
    polkit.enable = true;
  };


  sound.enable = true;
  sound.mediaKeys.enable = true;

  virtualisation.docker.enable = true;
}
