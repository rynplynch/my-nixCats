{ pkgs ? import <nixpkgs> { }
, self
, system
}:
with pkgs; let
  customNixCats =
    (self.packages.${system}.default.override (prev: {
      name = "minimal-vim";
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
