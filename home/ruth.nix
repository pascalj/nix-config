{ pkgs, config, lib, ... }:

{
  imports = [
  ];
  home.packages = with pkgs; [
    catppuccin-cursors
    catppuccin-gtk
    chromium
    cm_unicode
    dconf
    gnome3.adwaita-icon-theme
    libreoffice
    lmodern
    mosh
    nerdfonts
    networkmanagerapplet
    sd
    wdisplays
    wl-clipboard
    xfce.thunar
    xfce.thunar-volman
    zotero
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Pascal";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "teal" ];
        size = "compact";
        tweaks = [ "black" ];
        variant = "mocha";
      };
    };
    cursorTheme.name = "mochaTeal";
    cursorTheme.size = 24;
  };


  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = {
          normal.family = "Iosevka NF";
        };
        window = {
          padding = {
            x = 5;
            y = 5;
          };
        };

        # Colors (Mellow)
        colors = {
          primary = {
            background = "#161617";
            foreground = "#c9c7cd";
          };

          cursor = {
            text = "#c9c7cd";
            cursor = "#757581";
          };
          normal = {
            black = "#27272a";
            red = "#f5a191";
            green = "#90b99f";
            yellow = "#e6b99d";
            blue = "#aca1cf";
            magenta = "#e29eca";
            cyan = "#ea83a5";
            white = "#c1c0d4";
          };
          bright = {
            black = "#353539";
            red = "#ffae9f";
            green = "#9dc6ac";
            yellow = "#f0c5a9";
            blue = "#b9aeda";
            magenta = "#ecaad6";
            cyan = "#f591b2";
            white = "#cac9dd";
          };
        };

      };
    };
    i3status-rust = {
      enable = true;
      bars.default = {
        blocks = [
          {
            block = "weather";
            service = {
              name = "openweathermap";
              city_id = "2867714";
              api_key = "c910095a6f0870f4b0e96b698f275cf8";
            };
          }
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
          { block = "memory"; format = " $icon $mem_used_percents "; }
          { block = "cpu"; interval = 1; format_alt = " $icon $frequency "; }
          { block = "sound"; }
          { block = "backlight"; }
          { block = "battery"; format = " $icon  $percentage "; good = 99; }
          { block = "notify"; }
          {
            block = "time";
            interval = 1;
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
    kitty = {
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
    swaylock = {
      enable = true;
      settings = {
        color = "1e1e2e";
        bs-hl-color = "f5e0dc";
        caps-lock-bs-hl-color = "f5e0dc";
        caps-lock-key-hl-color = "a6e3a1";
        inside-color = "00000000";
        inside-clear-color = "00000000";
        inside-caps-lock-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        key-hl-color = "a6e3a1";
        layout-bg-color = "00000000";
        layout-border-color = "00000000";
        layout-text-color = "cdd6f4";
        line-color = "00000000";
        line-clear-color = "00000000";
        line-caps-lock-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        ring-color = "b4befe";
        ring-clear-color = "f5e0dc";
        ring-caps-lock-color = "fab387";
        ring-ver-color = "89b4fa";
        ring-wrong-color = "eba0ac";
        separator-color = "00000000";
        text-color = "cdd6f4";
        text-clear-color = "f5e0dc";
        text-caps-lock-color = "fab387";
        text-ver-color = "89b4fa";
        text-wrong-color = "eba0ac";
      };
    };
  };

  services = {
    dunst = {
      enable = true;
      settings = {
        global = {
          frame_color = "#89B4FA";
          separator_color = "frame";
        };

        urgency_low = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
        };

        urgency_normal = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
        };

        urgency_critical = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
          frame_color = "#FAB387";
        };
      };
    };
    network-manager-applet.enable = true;
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 600;
          command = "${config.wayland.windowManager.sway.package}/bin/swaymsg 'output * power off'";
          resumeCommand = "${config.wayland.windowManager.sway.package}/bin/swaymsg 'output * power on'";
        }
        {
          timeout = 900;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${config.programs.swaylock.package}/bin/swaylock -f";
        }
      ];
    };
    syncthing.enable = true;
  };

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    extraConfig = builtins.readFile ./dotfiles/i3config;
    config = {
      bars = [ ];
      input = {
        "*" = { xkb_layout = "eu"; };
        "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
          natural_scroll = "enabled";
          tap = "enabled";
        };
      };
      output = {
        "eDP-1" = {
          "scale" = "1.3";
        };
        "DP-9" = {
          "scale" = "1";
        };
      };
    };
    systemd.enable = true;
    wrapperFeatures.gtk = true;
  };

  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];
}
