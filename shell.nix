{ pkgs ? import <nixpkgs> { }
, self
, system
}:
with pkgs; mkShell {
  buildInputs = [
    nixpkgs-fmt
    neovim
  ];

  shellHook = ''
    # ...
  '';
}
