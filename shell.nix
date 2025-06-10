{ pkgs ? import <nixpkgs> { }
, self
, system
}:
with pkgs; mkShell {
  buildInputs = [
    self.packages.${system}.default
    nixpkgs-fmt
  ];

  shellHook = ''
    # ...
  '';
}
