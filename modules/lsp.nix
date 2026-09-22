{ config
, wlib
, lib
, pkgs
, options
, ...
}:
{
  options.settings.lsp = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config.specs.lsp = {
    enable = config.settings.lsp.enable;
    data = pkgs.vimPlugins.nvim-lspconfig;
    config = builtins.readFile ../configs/lsp.lua;
  };

  config.specs.lsp-blink_cmp = {
    enable = config.settings.lsp.enable;
    data = with pkgs.vimPlugins; [ blink-compat blink-cmp colorful-menu-nvim ];
    config = builtins.readFile ../configs/lsp-blink-cmp.lua;
  };

  # You can use the before and after fields to run them before or after other specs or spec of lists of specs
  config.specs.lsp-lua = {
    after = [ "lsp" ];
    enable = config.settings.lsp.enable;
    data = null;
    runtimePkgs = with pkgs; [
      lua-language-server
      stylua
    ];
    config = builtins.readFile ../configs/lsp-lua.lua;
  };

  config.specs.lsp-nix = {
    # mainInfo.nixdExtras = {
    #   nixpkgs = "import ${builtins.path { path = pkgs.path; }} {}";
    #   # get_configs = lib.generators.mkLuaInline # lua
    #   # ''function(type, path) return [[import ${./nixd.nix} "${pkgs.stdenv.hostPlatform.system}" "]] .. type .. [[" ]] .. (path or "./.") end'';
    # };
    enable = config.settings.lsp.enable;
    config = builtins.readFile ../configs/lsp-nix.lua;
    data = with pkgs; [
      vimPlugins.nvim-treesitter-parsers.nix
    ];
    runtimePkgs = with pkgs; [
      nil
      nixpkgs-fmt
    ];
  };

  config.specs.lsp-csharp = {
    enable = config.settings.lsp.enable;
    config = builtins.readFile ../configs/lsp-csharp.lua;
    data = with pkgs; [
      vimPlugins.nvim-treesitter-parsers.c_sharp
    ];
    runtimePkgs = with pkgs; [
      roslyn-ls
    ];
  };

  config.specs.lsp-orgmode = {
    enable = config.settings.lsp.enable;
    data = with config.nvim-lib.neovimPlugins; [
      orgmode
      orgroam-nvim
      org-bullets
      config.nvim-lib.grammars.org
    ];
    config = builtins.readFile ../configs/lsp-orgmode.lua;
  };
}
