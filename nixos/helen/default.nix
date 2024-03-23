{ config, pkgs, ... }:
let
  data = "/mnt/data";
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./blocky.nix
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

  environment.systemPackages = [ pkgs.restic ];

  networking = {
    hostName = "helen";
    # for ZFS
    hostId = "75290f93";
    firewall.allowedTCPPorts = [
      # restic
      8000
      # Paperless
      28981
      # syncthing
      8384
    ];
    firewall.allowedUDPPorts = [
      # blocky
      53
    ];
  };

  services = {
    restic.server = {
      enable = true;
      dataDir = "${data}/restic";
    };
    home-assistant = {
      enable = true;
      openFirewall = true;
      configDir = "${data}/home-assistant";
      config = { };
    };
    jellyfin = {
      enable = true;
      dataDir = "${data}/jellyfin";
      openFirewall = true;
    };
    paperless = {
      enable = true;
      dataDir = "${data}/paperless/data";
      mediaDir = "${data}/paperless/media";
      consumptionDir = "${data}/paperless/consumption";
      address = "0.0.0.0";
    };
    # ZFS snapshotting
    sanoid = {
      enable = true;
      datasets = {
        data = {
          hourly = 24;
          daily = 31;
          monthly = 12;
          yearly = 5;
        };
      };
    };
    syncthing = {
      enable = true;
      dataDir = "${data}/syncthing/";
      openDefaultPorts = true;
      overrideDevices = false;
      overrideFolders = false;
      guiAddress = "0.0.0.0:8384";
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };

    samba = {
      enable = true;
      openFirewall = true;
      securityType = "user";
      shares = {
        shared = {
          path = "${data}/shares/Shared";
          browsable = "yes";
          "read only" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "pascal";
          "force group" = "users";
        };
      };
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    mosh = {
      enable = true;
      openFirewall = true;
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  systemd.services."copy-restic" = {
    script = ''
      set -eu
      ${pkgs.restic}/bin/restic copy --from-repo /mnt/data/restic --from-password-file /etc/nixos/secrets/restic-local-password --repository-file /etc/nixos/secrets/hetzner-repository -p /etc/nixos/secrets/hetzner-password
    '';
    path = [ pkgs.openssh ];
    serviceConfig = {
      User = "restic";
    };
  };
  systemd.timers."copy-restic" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
    };
  };

  system.stateVersion = "23.11";
}
