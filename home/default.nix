{ config, pkgs, lib, ... }:
{
  imports = [
    ./home/neovim
    ./home/zsh
    ./home/dotfiles
  ];
  fonts.fontconfig.enable = true;

  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    bat
    btop
    fd
    htop
    lazygit
    nil
    ranger
    ripgrep
    rofimoji
    tailscale
    tree
    watson
  ];

  news.display = "silent";

  dotfiles.gdb-dashboard.enable = true;

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    git = {
      enable = true;
      userName = "Pascal Jungblut";
      userEmail = lib.mkDefault "mail@pascalj.de";
      ignores = [ ".lvimrc" ];
      aliases = {
        st = "status";
        co = "checkout";
      };
      diff-so-fancy.enable = true;
    };
    home-manager.enable = true;
    jq.enable = true;
    rofi = {
      enable = true;
      plugins = [ pkgs.rofi-calc ];
      theme = ./home/rofi/nord.rasi;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
  };

  services = {
    ssh-agent.enable = true;
  };
}
