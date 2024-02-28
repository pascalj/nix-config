{ pkgs, lib, ... }:
let
  gdb-dashboard = builtins.fetchurl {
    url = "https://git.io/.gdbinit";
    sha256 = "1gnhjl20yg2n6bks5v7jfv6sw68spp7gx437bqcnmrw141c4p359";
  };
in
{
}
