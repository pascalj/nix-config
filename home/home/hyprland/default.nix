{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
    libsForQt5.polkit-kde-agent
    hyprpaper
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    settings = {
      exec-once = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP";
      "$mod" = "SUPER";
      bind = [
        "$mod, Q, killactive,"
        "$mod, SPACE, exec, wofi --show drun"
        "$mod SHIFT, Q, exit,"
        "$mod SHIFT, SPACE, togglefloating,"
        "$mod, F, fullscreen"
        "$mod, RETURN, exec, kitty"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod SHIFT, y, exec,hyprctl keyword monitor \"eDP-1, disable\""
        "$mod, y, exec,hyprctl keyword monitor \"eDP-1, preferred, 0x0, 1.333\""
      ];

      ## Seems buggy atm
      # bindl = [
      #   ",switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, disable\""
      #   ",switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, preferred, 0x0, 1.333\""
      # ];

      # mouse
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # repeat
      binde = [
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ];

      animations = {
        animation = [
          "windows, 1, 2, default"
          "workspaces, 1, 2, default"
          "borderangle, 0"
        ];
      };

      dwindle = {
        no_gaps_when_only = true;
      };

      input = {
        kb_layout = "eu";

        touchpad = {
          natural_scroll = true;
        };
      };
      monitor = [
        "eDP-1,preferred,0x0,1.333"
        ",preferred,auto,1"

      ];

      general = {
        gaps_out = 5;
        resize_on_border = true;
      };
      decoration = {
        rounding = 3;
        drop_shadow = false;
        blur.enabled = false;
      };
      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        vfr = false;
      };
    };
    systemd.enable = true;
    xwayland.enable = true;
  };

  programs = {
    waybar = {
      enable = true;
      systemd.enable = true;
      settings = [{
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "network" "pulseaudio" "backlight" "battery" "clock" ];
        backlight = {
          device = "intel_backlight";
          format = "{icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            "default" = [ "" "" " " ];
          };
          on-click = "pavucontrol";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰂄";
          format-alt = "{icon}";
          format-icons = [ "󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" ];
        };

      }];
      style = ''
        @define-color base   #1e1e2e;
        @define-color mantle #181825;
        @define-color crust  #11111b;

        @define-color text     #cdd6f4;
        @define-color subtext0 #a6adc8;
        @define-color subtext1 #bac2de;

        @define-color surface0 #313244;
        @define-color surface1 #45475a;
        @define-color surface2 #585b70;

        @define-color overlay0 #6c7086;
        @define-color overlay1 #7f849c;
        @define-color overlay2 #9399b2;

        @define-color blue      #89b4fa;
        @define-color lavender  #b4befe;
        @define-color sapphire  #74c7ec;
        @define-color sky       #89dceb;
        @define-color teal      #94e2d5;
        @define-color green     #a6e3a1;
        @define-color yellow    #f9e2af;
        @define-color peach     #fab387;
        @define-color maroon    #eba0ac;
        @define-color red       #f38ba8;
        @define-color mauve     #cba6f7;
        @define-color pink      #f5c2e7;
        @define-color flamingo  #f2cdcd;
        @define-color rosewater #f5e0dc;

        * {
          font-family: Ubuntu Nerd Font;
          font-size: 14px;
          min-height: 0;
        }

        #waybar {
          background: transparent;
          color: @text;
          margin: 2px 5px;
        }

        #workspaces {
          border-radius: 1rem;
          margin: 3px;
          background-color: @surface0;
          margin-left: 1rem;
        }

        #workspaces button {
          color: @lavender;
          border-radius: 1rem;
          padding: 0.4rem;
        }

        #workspaces button.active {
          color: @sky;
          border-radius: 1rem;
        }

        #workspaces button:hover {
          color: @sapphire;
          border-radius: 1rem;
        }

        #custom-music,
        #tray,
        #backlight,
        #clock,
        #battery,
        #pulseaudio,
        #custom-lock,
        #custom-power {
          background-color: @surface0;
          padding: 0.5rem 1rem;
          margin: 3px 0;
        }

        #clock {
          color: @blue;
          border-radius: 0px 1rem 1rem 0px;
          margin-right: 1rem;
        }

        #battery {
          color: @green;
        }

        #battery.charging {
          color: @green;
        }

        #battery.warning:not(.charging) {
          color: @red;
        }

        #backlight {
          color: @yellow;
        }

        #backlight, #battery {
            border-radius: 0;
        }

        #pulseaudio {
          color: @maroon;
          border-radius: 1rem 0px 0px 1rem;
          margin-left: 1rem;
        }

        #custom-music {
          color: @mauve;
          border-radius: 1rem;
        }

        #custom-lock {
            border-radius: 1rem 0px 0px 1rem;
            color: @lavender;
        }

        #custom-power {
            margin-right: 1rem;
            border-radius: 0px 1rem 1rem 0px;
            color: @red;
        }

        #tray {
          margin-right: 1rem;
          border-radius: 1rem;
        }
      '';
    };
    wofi = {
      enable = true;
    };
  };

  xdg.configFile = {
    "hypr/hyprpaper.conf".text = ''
      preload = /home/pascal/Downloads/wallpaper.svg
      wallpaper = ,/home/pascal/Downloads/wallpaper.svg
    '';
  };

  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];
}
