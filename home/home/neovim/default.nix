{ pkgs, ... }:

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
  extraLuaConfig = "require(\"init\")";

  extraPackages = with pkgs; [
    lua-language-server
  ];

  plugins = with pkgs.vimPlugins; [
    catppuccin-nvim
    gitsigns-nvim
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
        lua
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

