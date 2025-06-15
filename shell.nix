{ pkgs ? import <nixpkgs> { }
, nixCats
, self
, system
}:
with pkgs; let
  customNixCats =
    (self.packages.${system}.default.override (prev: {
      name = "minimal-vim";
      categoryDefinitions = nixCats.utils.mergeCatDefs prev.categoryDefinitions ({ pkgs, settings, categories, name, extra, mkPlugin, ... }@packageDef: {
        optionalLuaAdditions = {
          newcat =
        };
      });
      packageDefinitions = prev.packageDefinitions // {
        minimal-vim = nixCats.utils.mergeCatDefs prev.packageDefinitions.nvim ({ pkgs, ... }: {
        });
      };
    }));
in
mkShell {
  buildInputs = [
    customNixCats
    nixpkgs-fmt
  ];

  shellHook = ''
    # ...
  '';
}
