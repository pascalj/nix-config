{ lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };


  environment.systemPackages = with pkgs; [ 
    wayland
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme  # default gnome cursors
    swaylock
    swayidle
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu # wayland clone of dmenu
    mako # notification system developed by swaywm maintainer
    wdisplays # tool to configure displays
  ];

  # Smooth scrolling in Firefox
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  hardware.pulseaudio.enable = true;

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

  # services.xserver = {
  #   layout = "eu";
  #   enable = true;
  #   desktopManager = {
  #     xterm.enable = false;
  #     xfce = {
  #       enable = true;
  #       noDesktop = true;
  #       enableXfwm = false;
  #     };
  #   };
  #   displayManager.defaultSession = "xfce+i3";
  #   windowManager.i3.enable = true;
  #   libinput = {
  #     enable = true;
  #     touchpad.naturalScrolling = true;
  #   };
  # };
  # sway:
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  programs.light.enable = true;

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

  sound.enable = true;
  sound.mediaKeys.enable = true;

  virtualisation.docker.enable = true;
}
