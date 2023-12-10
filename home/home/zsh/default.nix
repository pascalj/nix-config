{ config, lib, pkgs }:

{
  enable = true;

  dotDir = ".config/zsh";

  autocd = true;


  history = {
    size = 10000;
    save = 10000;
    ignoreDups = true;
    ignoreSpace = true;
    extended = true;
    share = false;
    path = "${config.xdg.dataHome}/zsh/zsh_history";
  };

  shellAliases = {
    vim = "nvim";
    st = "git status";
    ls = "ls --color=auto";
    lg = "lazygit";
    nd = "nix develop --command zsh";
    wa = "watson";

    # gs
    bios = "cmake --build /home/pascal/src/appsweep/ios/cmake-build-debug --target appsweep-ios";
    rlit = "cmake --build /home/pascal/src/appsweep/ios/cmake-build-debug --target run_lit";
  };

  initExtra = lib.fileContents ./zshrc;

  plugins = [
    {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.5.0";
        sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
      };
    }
  ];
}

