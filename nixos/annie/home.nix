{ config, pkgs, lib, ... }:

{
  home.file."containers" = {
    source = ./containers;
  };
}
