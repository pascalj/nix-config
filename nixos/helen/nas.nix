{ pkgs, config, lib, ... }:
let cfg = config.nas;
in {
  options.nas.pool = lib.mkOption {
    type = lib.types.str;
    default = "/mnt/data";
  };

  config = {
    services = {
      restic.server = {
        enable = true;
        dataDir = "${cfg.pool}/restic";
      };
      home-assistant = {
        enable = true;
        openFirewall = true;
        configDir = "${cfg.pool}/home-assistant";
        config = { };
      };
      jellyfin = {
        enable = true;
        dataDir = "${cfg.pool}/jellyfin";
        openFirewall = true;
      };
      paperless = {
        enable = true;
        address = "0.0.0.0";
        consumptionDir = "${cfg.pool}/paperless/consumption";
        dataDir = "${cfg.pool}/paperless/data";
        mediaDir = "${cfg.pool}/paperless/media";
      };
      photoprism = {
        enable = true;
        address = "0.0.0.0";
        originalsPath = "${cfg.pool}/photoprism/originals";
        storagePath = "${cfg.pool}/photoprism/storage";
        passwordFile = "/etc/nixos/secrets/photoprism";
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
        dataDir = "${cfg.pool}/syncthing/";
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
        # iOS interoperability
        extraConfig = ''
          vfs objects = fruit streams_xattr  
          fruit:metadata = stream
          fruit:model = MacSamba
          fruit:posix_rename = yes 
          fruit:veto_appledouble = no
          fruit:nfs_aces = no
          fruit:wipe_intentionally_left_blank_rfork = yes 
          fruit:delete_empty_adfiles = yes 
        '';
        shares = {
          shared = {
            path = "${cfg.pool}/shares/Shared";
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
      restic.backups = {
        data = {
          paths = [
            "${cfg.pool}/paperless"
            "${cfg.pool}/shares"
            "${cfg.pool}/photoprism"
          ];
          passwordFile = "/etc/nixos/secrets/hetzner-password";
          repositoryFile = "/etc/nixos/secrets/hetzner-repository";
          pruneOpts = [
            "--keep-daily 7"
            "--keep-weekly 5"
            "--keep-monthly 13"
            "--keep-yearly 10"
          ];
        };
      };
    };

    # copy the restic backups to hetzner
    systemd.services."copy-restic" = {
      script = ''
        set -eu
        ${pkgs.restic}/bin/restic copy --from-repo ${cfg.pool}/restic --from-password-file /etc/nixos/secrets/restic-local-password --repository-file /etc/nixos/secrets/hetzner-repository -p /etc/nixos/secrets/hetzner-password -h
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
  };
}

