{ pkgs, lib, ... }:

let
  configuration = pkgs.vimUtils.buildVimPlugin {
    pname = "configuration";
    version = "v1.0.0";
    src = ./.;
  };
in
{
  enable = true;
  viAlias = true;
  vimAlias = true;
  withRuby = false;
  withNodeJs = false;

  extraConfig = lib.fileContents ./init.vim;

  plugins = with pkgs.vimPlugins; [
    catppuccin-nvim
    goto-preview
    lualine-nvim
    minimap-vim
    nvim-autopairs
    nvim-lspconfig
    nvim-navic
    telescope-nvim
    vim-commentary
    vim-dispatch
    vim-fugitive
    vim-localvimrc
    vim-nix
    vim-sleuth
    vim-surround
    (nvim-treesitter.withPlugins (
      plugins: with plugins; [
        c
        cpp
        latex
        markdown
        nix
        python
        r
        typescript
      ]
    ))
    configuration
  ];
}

