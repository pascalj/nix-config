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
        dataDir = "${cfg.pool}/paperless/data";
        mediaDir = "${cfg.pool}/paperless/media";
        consumptionDir = "${cfg.pool}/paperless/consumption";
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

