{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    ghidra-bin
    radare2
    hexyl
    nodejs_20
    gdbHostCpuOnly
    compdb
    # plistutil # to package...
    # arcanist # package broken?
    # cmakeCurses # fucks up OpenSSL
    lit
    # :'-)
    playwright
    nodePackages.typescript-language-server
  ];

  programs.git.userEmail = "pascal.jungblut@guardsquare.com";
}
