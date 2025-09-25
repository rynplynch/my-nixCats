{ inputs, ... }@attrs:
let
  inherit (inputs) nixpkgs;# <-- nixpkgs = inputs.nixpkgsSomething;
  inherit (inputs.nixCats) utils;
  luaPath = ./.;
  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  # the following extra_pkg_config contains any values
  # which you want to pass to the config set of nixpkgs
  # import nixpkgs { config = extra_pkg_config; inherit system; }
  extra_pkg_config = {
    # allowUnfree = true;
  };
  dependencyOverlays = /* (import ./overlays inputs) ++ */ [
    # see :help nixCats.flake.outputs.overlays
    # This overlay grabs all the inputs named in the format
    # `plugins-<pluginName>`
    # Once we add this overlay to our nixpkgs, we are able to
    # use `pkgs.neovimPlugins`, which is a set of our plugins.
    (utils.standardPluginOverlay inputs)
    # add any flake overlays here.
    (utils.standardPluginOverlay {
      plugins-lazygit-nvim = inputs.lazygit-nvim;
      plugins-osv-nvim = inputs.osv-nvim;
    })
    # when other people mess up their overlays by wrapping them with system,
    # you may instead call this function on their overlay.
    # it will check if it has the system in the set, and if so return the desired overlay
    # (utils.fixSystemizedOverlay inputs.codeium.overlays
    #   (system: inputs.codeium.overlays.${system}.default)
    # )
  ];

  categoryDefinitions = { pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
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
          # ensure the enviroment has git
          git
          # bridge between nvim clip registers and system clipboard
          xclip
          ;
      };
      # language dependencies
      lua = with pkgs; [
        lua-language-server
        # luajitPackages.luacheck
      ];

      nix = with pkgs; [
        nil
        nixpkgs-fmt
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
          Preview-nvim
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
  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
  defaultPackageName = "nvim";
in
# see :help nixCats.flake.outputs.exports
forEachSystem
  (system:
    let
      nixCatsBuilder = utils.baseBuilder luaPath
        {
          inherit system dependencyOverlays extra_pkg_config nixpkgs;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;
      # this is just for using utils such as pkgs.mkShell
      # The one used to build neovim is resolved inside the builder
      # and is passed to our categoryDefinitions and packageDefinitions
      pkgs = import nixpkgs { inherit system; };
    in
    {
      # this will make a package out of each of the packageDefinitions defined above
      # and set the default package to the one passed in here.
      packages = utils.mkAllWithDefault defaultPackage;

      # choose your package for devShell
      # and add whatever else you want in it.
      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [ defaultPackage ];
          inputsFrom = [ ];
          shellHook = ''
        '';
        };
      };

    }) // (
  let
    # we also export a nixos module to allow reconfiguration from configuration.nix
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [ "ryanl-editor" ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
  in
  {

    # these outputs will be NOT wrapped with ${system}

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays = utils.makeOverlays luaPath
      {
        # we pass in the things to make a pkgs variable to build nvim with later
        inherit nixpkgs dependencyOverlays extra_pkg_config;
        # and also our categoryDefinitions
      }
      categoryDefinitions
      packageDefinitions
      defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  }
)
