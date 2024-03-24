{ pkgs, lib, config, ... }:
let
  gdb-dashboard = builtins.fetchurl {
    url = "https://git.io/.gdbinit";
    sha256 = "1gnhjl20yg2n6bks5v7jfv6sw68spp7gx437bqcnmrw141c4p359";
  };
  cfg = config.dotfiles;
in
  {
    options.dotfiles = {
      gdb-dashboard.enable = lib.mkEnableOption "gdb-dashboard";
    };
    config = {
      home.file = {
        ".gdbinit".source = lib.mkIf cfg.gdb-dashboard.enable gdb-dashboard;
      };
      xdg.configFile = {
        "i3/config".source = ./i3config;
        "rofimoji.rc".text = ''
          action = copy
          skin-tone = neutral
          max-recent = 0
        '';
      };
    };
}
