{ config, pkgs, ... }:
let
  data = "/mnt/data";
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl."net.ipv4.ip_forward" = 1;
  };
  networking.hostName = "helen"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "75290f93";

  services = {
    blocky = {
      enable = true;
    };
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pascal = {
    isNormalUser = true;
    description = "Pascal Jungblut";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    # blocky
    53
    # restic
    8000
    # Paperless
    28981
    # syncthing
    8384
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
