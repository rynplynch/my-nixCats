{
  description = "An over-engineered Hello World in C";

  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    lazygit-nvim = {
      url = "github:kdheepak/lazygit.nvim";
      flake = false;
    };
    osv-nvim = {
      url = "github:jbyuki/one-small-step-for-vimkind";
      flake = false;
    };
  };
  outputs =
    { self
    , nixpkgs
    , nixCats
    , ...
    }@inputs:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        }
      );

      dependencyOverlays = # (import ./overlays inputs) ++
        [
          (nixCats.utils.standardPluginOverlay {
            plugins-lazygit-nvim = inputs.lazygit-nvim;
            plugins-osv-nvim = inputs.osv-nvim;
          })
        ];
    in

    {

      # A Nixpkgs overlay.
      overlay = final: prev: { };

      # Provide some binary packages for selected system types.
      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      packages = forAllSystems (
        system:
        nixCats.utils.mkAllWithDefault (
          import ./default.nix (
            inputs
            // {
              inherit (nixpkgsFor.${system}) pkgs;
              inherit inputs dependencyOverlays;
            }
          )
        )
      );

      defaultPackage = forAllSystems (system: self.packages.${system}.default);

      devShells = forAllSystems (system: {
        default = import ./shell.nix {
          inherit nixCats self system;
          pkgs = nixpkgsFor.${system};
        };
      });
    };
}
