{ lib, pkgs, ... }:

{
  imports = [ (import ./hardware-configuration.nix) ];

  networking.firewall.allowedTCPPorts = [ 80 443 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 ];

  services = {
    caddy = {
      enable = true;

      virtualHosts."vault.pascalj.de".extraConfig = ''
        reverse_proxy localhost:8555
        reverse_proxy /notifications/hub localhost:3012
      '';

      virtualHosts."actual.pascalj.de".extraConfig = ''
        reverse_proxy localhost:5006
      '';

      virtualHosts."sync.pascalj.de".extraConfig = ''
        reverse_proxy localhost:8384
      '';

      virtualHosts."irc.pascalj.de".extraConfig = ''
        reverse_proxy localhost:9000
      '';

      virtualHosts."rss.pascalj.de".extraConfig = ''
        reverse_proxy localhost:8556
      '';
      virtualHosts."read.pascalj.de".extraConfig = ''
        reverse_proxy localhost:8557
      '';
      virtualHosts."bookmarks.pascalj.de".extraConfig = ''
        reverse_proxy localhost:8558
      '';
      virtualHosts."todo.pascalj.de".extraConfig = ''
        reverse_proxy localhost:8560
      '';

      virtualHosts."www.pascalj.de".extraConfig = ''
        redir https://pascal.jungblut.me{uri}
      '';

      virtualHosts."pascalj.de".extraConfig = ''
        redir https://pascal.jungblut.me{uri}
      '';

      virtualHosts."jungblut.me".extraConfig = ''
        redir https://pascal.jungblut.me{uri}
      '';

      virtualHosts."pascal.jungblut.me".extraConfig = ''
        root * /var/www/pascalj.de
        file_server
      '';
    };
  };
  virtualisation.docker.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  environment.systemPackages = [
    pkgs.docker-compose
  ];

  networking.hostName = "annie";

  services.openssh.enable = true;

  programs.mosh.enable = true;
}
