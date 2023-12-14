{ lib, pkgs, config, ... }:

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
      virtualHosts."headscale.pascalj.de".extraConfig = ''
        reverse_proxy localhost:8561
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
      virtualHosts."pascalj.de".extraConfig = ''
        root * /var/www/pascalj.de
        file_server
      '';
      virtualHosts."www.pascalj.de".extraConfig = ''
        redir https://pascalj.de{uri}
      '';
      virtualHosts."jungblut.me".extraConfig = ''
        redir https://pascalj.de{uri}
      '';
    };
    headscale = {
      enable = true;
      port = 8561;
      serverUrl = "https://headscale.pascalj.de";
      dns = { baseDomain = "pascalj.de"; };
    };
    openssh.enable = true;
    tailscale.enable = true;
  };
  virtualisation.docker.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  environment.systemPackages = with pkgs; [
    docker-compose
    mosh
  ];

  networking.hostName = "annie";

  programs.mosh.enable = true;

  users.users.git = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = config.users.users.pascal.openssh.authorizedKeys.keys;
  };
}
