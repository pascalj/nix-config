{ lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_7;
    kernelParams = [ "amdgpu.sg_display=0" ];
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
    systemPackages = with pkgs; [
      brightnessctl
      cifs-utils
      linuxKernel.packages.linux_6_7.vmware
      wayland
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
    ];
  };

  # Smooth scrolling in Firefox

  hardware = {
    pulseaudio.enable = true;
    opengl.enable = true;

    # https://github.com/NixOS/nixos-hardware/pull/778
    framework.amd-7040.preventWakeOnAC = true;
  };

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices."luks-6ab21dc8-6040-4a8f-adfd-df00ead54cd0".device = "/dev/disk/by-uuid/6ab21dc8-6040-4a8f-adfd-df00ead54cd0";
  networking = {
    hostName = "ruth";
    hosts = {
      "127.0.0.1" = [ "mklocal.localhost" ];
    };
    networkmanager.enable = true;
  };

  nixpkgs.config = {
    permittedInsecurePackages = [
      "electron-25.9.0"

    ];
    zathura.useMupdf = false;
  };

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
    dconf.enable = true;
    hyprland.enable = true;
  };

  # For mount.cifs, required unless domain name resolution is not needed.
  fileSystems."/home/pascal/Helen" = {
    device = "//helen/shared";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user=pascal";
      in
      [ "${automount_opts},credentials=/etc/nixos/secrets/smb,uid=1000,gid=100" ];
  };

  services = {
    dbus.enable = true;
    getty.autologinUser = "pascal";
    power-profiles-daemon.enable = lib.mkDefault true;
    fprintd.enable = true;
    fwupd.enable = true;
    logind = {
      lidSwitchDocked = "ignore";
      lidSwitch = "suspend";
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
    };

    udev.extraRules = ''
      # Rules for Oryx web flashing and live training
      KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", TAG+="uaccess"

      # Legacy rules for live training over webusb (Not needed for firmware v21+)
        # Rule for all ZSA keyboards
        SUBSYSTEM=="usb", ATTR{idVendor}=="3297", TAG+="uaccess"
        # Rule for the Moonlander
        SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", TAG+="uaccess"
        # Rule for the Ergodox EZ
        SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", TAG+="uaccess"
        # Rule for the Planck EZ
        SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", TAG+="uaccess"

      # Wally Flashing rules for the Ergodox EZ
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

      # Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
      # Keymapp Flashing rules for the Voyager
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"

      # disable USB receiver wake-up
      ACTION=="add", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c548", ATTR{power/wakeup}="disabled"
    '';
    # tailscale.enable = true;
    restic.backups = {
      pascal = {
        paths = [
          "/home/pascal/"
        ];
        exclude = [
          "vms"
          ".ngrams"
          ".cache"
        ];
        passwordFile = "/home/pascal/.restic-password";
        repositoryFile = "/home/pascal/.restic-repository";
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--keep-yearly 10"
        ];
      };
    };
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
    pam.services.swaylock = {
      text = ''
        auth sufficient pam_unix.so try_first_pass likeauth nullok
        auth sufficient pam_fprintd.so
        auth include login
      '';
    };
    polkit.enable = true;
  };

  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services = {
    NetworkManager-wait-online.enable = lib.mkForce false;
    systemd-networkd-wait-online.enable = lib.mkForce false;
  };


  sound.enable = true;
  sound.mediaKeys.enable = true;

  virtualisation = {
    # docker.enable = true;
    vmware.host.enable = true;
  };
}
