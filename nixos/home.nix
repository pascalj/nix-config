{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "pascal";
  home.homeDirectory = "/home/pascal";


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = [
    pkgs.bat
    pkgs.clang-tools
    pkgs.fd
    pkgs.htop
    pkgs.ripgrep
    pkgs.lazygit
    pkgs.zulip-term
  ];
  programs.jq.enable = true;
  programs.rofi = {
    enable = false;
    plugins = [ pkgs.rofi-calc ];
    theme = "${config.xdg.configHome}/nixpkgs/home/rofi/nord.rasi";
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Pascal Jungblut";
    userEmail = "mail@pascalj.de";
    ignores = [ ".lvimrc" ];
  };

  programs.neovim = import ./home/neovim.nix {
    inherit pkgs lib;
  };

  programs.zsh = import ./home/zsh.nix {
    inherit config lib pkgs;
  };

}
