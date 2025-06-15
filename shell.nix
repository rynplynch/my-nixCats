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
            let
              newDir = "/home/ryanl/git-repos/my-nixCats";
            in
              /*lua*/''
              local newCfgDir = [[${newDir}]]
            '';
        };
      });
      packageDefinitions = prev.packageDefinitions // {
        minimal-vim = nixCats.utils.mergeCatDefs prev.packageDefinitions.nvim ({ pkgs, ... }: {
          categories = {
            newcat = true;
          };
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
