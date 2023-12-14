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
    systemPackages = with pkgs; [ brightnessctl wayland ];
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
  programs = {
    dconf.enable = true;
  };
  services = {
    getty.autologinUser = "pascal";
    power-profiles-daemon.enable = lib.mkDefault true;
    fprintd.enable = lib.mkDefault true;

    udev.extraRules = ''
      # Rules for Oryx web flashing and live training
      KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
      KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

      # Legacy rules for live training over webusb (Not needed for firmware v21+)
        # Rule for all ZSA keyboards
        SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
        # Rule for the Moonlander
        SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
        # Rule for the Ergodox EZ
        SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
        # Rule for the Planck EZ
        SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"

      # Wally Flashing rules for the Ergodox EZ
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

      # Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
      # Keymapp Flashing rules for the Voyager
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
    '';
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
      pavucontrol
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