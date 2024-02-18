{ pkgs, ... }:

let
  configuration = pkgs.vimUtils.buildVimPlugin {
    pname = "configuration";
    version = "v1.0.0";
    src = ./.;
  };
  clang-tools = pkgs.clang-tools_17;
in
{
  enable = true;
  viAlias = true;
  vimAlias = true;
  withRuby = false;
  withNodeJs = false;
  extraLuaConfig = "require(\"init\")";

  extraPackages = with pkgs; [
    # Create dummy binaries to pin the version and use the wrapped versions for neovim
    (pkgs.writeShellScriptBin "clangd-vim" "${clang-tools}/bin/clangd $@")
    (pkgs.writeShellScriptBin "clang-tidy-vim" "${clang-tools}/bin/clang-tidy $@")
    lua-language-server
    ltex-ls
    nodePackages.pyright
  ];

  plugins = with pkgs.vimPlugins; [
    catppuccin-nvim
    cmp-nvim-lsp
    cmp-nvim-lsp-signature-help
    cmp-path
    gitsigns-nvim
    goto-preview
    lualine-nvim
    minimap-vim
    nvim-autopairs
    nvim-cmp
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

