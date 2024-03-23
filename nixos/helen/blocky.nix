{ ... }:
{
  services.blocky = {
    enable = true;
    settings = {
      upstreams = {
        groups = {
          default = [
            "5.9.164.112"
            "1.1.1.1"
            "tcp-tls:fdns1.dismail.de:853"
            "https://dns.digitale-gesellschaft.ch/dns-query"
          ];
        };
      };
      conditional = {
        mapping = {
          "fritz.box" = "192.168.178.1";
        };
      };
      clientLookup = {
        upstream = "192.168.178.1";
      };
      blocking.blackLists.ads = [
        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt"
      ];
    };
  };
}
