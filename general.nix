{
  config,
  wlib,
  lib,
  pkgs,
  options,
  ...
}:
{
  config.specs.neogit = {
    # note we didn't have to specify the `lze` specs name, because it was a top level spec
    data = [
        config.nvim-lib.neovimPlugins.neogit
    ];
  };
}
