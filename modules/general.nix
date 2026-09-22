{ config
, wlib
, lib
, pkgs
, options
, ...
}:
{
  options.settings.general = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    neogit = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    oil = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    vimstart = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    telescope = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    moonfly-colors = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config.specs.neogit = {
    enable = if (config.settings.general.enable || config.settings.general.neogit) then true else false;
    # note we didn't have to specify the `lze` specs name, because it was a top level spec
    data = config.nvim-lib.neovimPlugins.neogit;
    config = builtins.readFile ../configs/general-neogit.lua;
  };

  config.specs.oil = {
    enable = if (config.settings.general.enable || config.settings.general.oil) then true else false;
    data = pkgs.vimPlugins.oil-nvim;
    config = builtins.readFile ../configs/general-oil.lua;
  };

  config.specs.vimstart = {
    enable = if (config.settings.general.enable || config.settings.general.vimstart) then true else false;
    # note we didn't have to specify the `lze` specs name, because it was a top level spec
    # lazy = true;
    data = with pkgs.vimPlugins; [
      vim-startuptime
    ];
    config = builtins.readFile ../configs/general-vimstart.lua;
  };

  config.specs.telescope = {
    enable = if (config.settings.general.enable || config.settings.general.telescope) then true else false;
    data = pkgs.vimPlugins.telescope-nvim;
    runtimePkgs = with pkgs; [
      ripgrep
    ];
    config = builtins.readFile ../configs/general-telescope.lua;
  };

  config.specs.moonfly-colors = {
    enable = if (config.settings.general.enable || config.settings.general.moonfly-colors) then true else false;
    data = pkgs.vimPlugins.vim-moonfly-colors;
    config = builtins.readFile ../configs/general-moonfly-colors.lua;
  };
}
