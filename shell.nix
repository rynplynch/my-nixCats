{ pkgs ? import <nixpkgs> { }
, neovim
,
}:
with pkgs;
let
   nvim-dev = neovim.wrap  {
        config = {
            binName = "nvim-dev";
            settings.dont_link = true;
            settings.config_directory = lib.generators.mkLuaInline "vim.uv.cwd()";
        };
    };
in
mkShell {
  buildInputs = [
    nvim-dev
  ];

  shellHook = ''
    # ...
  '';
}
