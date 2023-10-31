{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [

  ];

  services.syncthing.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka NF";
      size = 12;
    };
    shellIntegration.enableZshIntegration = true;
    theme = "Catppuccin-Mocha";
    settings = {
      background = "#050505";
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars.default = {
      blocks = [
        {
          block = "net";
          format_alt = "$icon ^icon_net_down $graph_down ^icon_net_up $graph_up ";
        }
        {
          block = "disk_space";
          path = "/";
          info_type = "available";
          interval = 60;
          warning = 20.0;
          alert = 10.0;
        }
        {
          block = "memory";
          format = " $icon $mem_used_percents ";
        }
        {
          block = "cpu";
          interval = 1;
        }
        {
          block = "load";
          interval = 1;
          format = " $icon $1m ";
        }
        { block = "sound"; }
        {
          block = "time";
          interval = 60;
          format = " $timestamp.datetime(f:'%a %d/%m %R') ";
        }
      ];
      settings = {
        theme = {
          theme = "ctp-mocha";
          overrides = {
            idle_bg = "#303030";
            separator = "";
          };
        };
      };
      icons = "awesome4";
      theme = "ctp-mocha";
    };
  };
}
