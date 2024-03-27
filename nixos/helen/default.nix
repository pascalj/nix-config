{ config, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./blocky.nix
      ./nas.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Tailscale exit node
    kernel.sysctl."net.ipv4.ip_forward" = 1;
    zfs = {
      extraPools = [ "data" ];
      forceImportRoot = false;
    };
    supportedFilesystems = [ "zfs" ];
  };

  environment.systemPackages = [ ];

  networking = {
    networkmanager.enable = true;
    hostName = "helen";
    # for ZFS
    hostId = "75290f93";
    firewall = {
      allowedTCPPorts = [
        # restic
        8000
        # Paperless
        28981
        # syncthing
        8384
        config.services.photoprism.port
      ];
      allowedUDPPorts = [
        # blocky
        53
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
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

  programs = {
    mosh = {
      enable = true;
      openFirewall = true;
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "23.11";
}
