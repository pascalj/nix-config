# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pascal = {
    isNormalUser = true;
    description = "Pascal Jungblut";
    extraGroups = [ "wheel" "docker" "plugdev" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfUommyKXb6CiXOGPiCJ84WhafGn1ME3bAd4h7G3zJC carol"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF38tclD2a4IUpED4FCwgxPkbtU5JQ8naKSzCmr7DGjW pascal@nixos"
    ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    home-manager
  ];

  programs.zsh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}

