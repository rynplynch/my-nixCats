{ pkgs ? import <nixpkgs> { }
, inputs
, dependencyOverlays
, nixCats ? builtins.fetchGit {
    url = "https://github.com/BirdeeHub/nixCats-nvim";
  }
, ...
}:
let
  # get the nixCats library with the builder function (and everything else) in it
  utils = import nixCats;
  # path to your new .config/nvim
  luaPath = ./.;

  # see :help nixCats.flake.outputs.categories
  categoryDefinitions =
    { pkgs
    , settings
    , categories
    , extra
    , name
    , mkPlugin
    , ...
    }@packageDef:
    {
      lspsAndRuntimeDeps = {
        # dependencies I always use while developing
        dev = {
          inherit (pkgs)
            # provides UI for everything git
            lazygit
            # quick search for files
            fd
            # quick searching for text in files
            ripgrep
            ;
        };
        # language dependencies
        lua = with pkgs; [
          lua-language-server
          # luajitPackages.luacheck
        ];

        nix = with pkgs; [
          nil
          nixfmt-rfc-style
        ];

        csharp = with pkgs; [
          roslyn-ls
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {

        dev = {
          inherit (pkgs.vimPlugins)
            # nvim-treesitter
            nvim-lspconfig
            blink-cmp
            oil-nvim
            telescope-nvim
            mini-ai
            mini-pairs
            ;
          inherit (pkgs.neovimPlugins) lazygit-nvim;
        };
        ui = {
          inherit (pkgs.vimPlugins)
            mini-icons
            lualine-nvim
            onedark-nvim
            lualine-lsp-progress
            ;
        };
        debug = {
          inherit (pkgs.vimPlugins) nvim-dap nvim-dap-ui nvim-dap-virtual-text;
          inherit (pkgs.neovimPlugins) osv-nvim;
        };

        general = with pkgs.vimPlugins; [
          vim-sleuth
          gitsigns-nvim
        ];
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      optionalPlugins = {
        lua = with pkgs.vimPlugins; [
          lazydev-nvim
        ];

        nix = with pkgs; [
          vimPlugins.nvim-treesitter-parsers.nix
        ];

        csharp = with pkgs; [
          vimPlugins.nvim-treesitter-parsers.c_sharp
        ];
      };
    };

  # see :help nixCats.flake.outputs.packageDefinitions
  packageDefinitions = {
    # These are the names of your packages
    # you can include as many as you wish.
    # each of these sets are also written into the nixCats plugin for querying within lua.
    nvim =
      { pkgs
      , name
      , mkPlugin
      , ...
      }:
      {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          # see :help nixCats.flake.outputs.settings
          # IMPORTANT:
          # your aliases may not conflict with other packages.
          # aliases = [ "vim" ];
          hosts.python3.enable = false;
          hosts.node.enable = false;
          hosts.ruby.enable = false;
          hosts.perl.enable = false;
        };
        # and a set of categories that you want
        # All categories you wish to include must be marked true
        categories = {
          # defaults for categories that all editor version will use
          dev = true;
          debug = true;
        };
        # anything else to pass and grab in lua with `nixCats.extra`
        extra = {
          nixdExtras.nixpkgs = ''import ${pkgs.path} {}'';
          nixdExtras.nixos_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").nixosConfigurations.configname.options'';
        };
      };
  };

  # We will build the one named nvim here and export that one.
  defaultPackageName = "nvim";
  # return our package!
in
utils.baseBuilder luaPath
{
  inherit pkgs dependencyOverlays;
}
  categoryDefinitions
  packageDefinitions
  defaultPackageName
# NOTE: or to return a set of all of them:
# `in utils.mkAllPackages (utils.baseBuilder luaPath { inherit pkgs; } categoryDefinitions packageDefinitions defaultPackageName)`
# NOTE: you may call .overrideNixCats on the resulting package or packages
# to construct different packages from
# your packageDefinitions from the resulting derivation of this expression!
# `finalPackage.overrideNixCats { name = "aDifferentPackage"; }`
# see :h nixCats.overriding
