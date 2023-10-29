{ config, pkgs, lib, ... }:
{
  fonts.fontconfig.enable = true;

  home.file = import ./home/dotfiles {
    inherit pkgs lib;
  };
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    bat
    fd
    htop
    ripgrep
    lazygit
    watson
    iosevka
    tree
  ];

  news.display = "silent";

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
    neovim = import ./home/neovim {
      inherit pkgs lib;
    };
    rofi = {
      enable = true;
      plugins = [ pkgs.rofi-calc ];
      theme = ./home/rofi/nord.rasi;
    };
    zsh = import ./home/zsh {
      inherit config lib pkgs;
    };
  };

  services = {
    ssh-agent.enable = true;
  };
}
