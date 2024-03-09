{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    ghidra-bin
    radare2
    hexyl
    nodejs_20
    gdbHostCpuOnly
    compdb
    cmake-format
    # plistutil # to package...
    # arcanist # package broken?
    # cmakeCurses # fucks up OpenSSL
    # (python311.withPackages(ps: with ps; [
    #   lit
    #   requests
    # ]))
    # :'-)
    playwright
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.pnpm

    catppuccin-cursors
    catppuccin-gtk
    dconf
    gnome3.adwaita-icon-theme
    nerdfonts

    clang-tools_17
  ];

  programs.git.userEmail = "pascal.jungblut@guardsquare.com";

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
    i3status-rust = {
      enable = true;
      bars.default = {
        blocks = [
          {
            block = "watson";
            show_time = true;
          }
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
          { block = "backlight"; }
          { block = "battery"; }
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
        name = "Iosevka Nerd Font";
        size = 13;
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
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 900;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
    syncthing.enable = true;
  };
}
