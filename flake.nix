{
  description = "Flake exporting a configured neovim package";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.wrappers.url = "github:nix-community/nix-wrapper-modules";
  inputs.wrappers.inputs.nixpkgs.follows = "nixpkgs";
  inputs.plugins-neogit = {
    url = "github:NeogitOrg/neogit";
    flake = false;
  };
  inputs.plugins-orgmode = {
    url = "github:nvim-orgmode/orgmode";
    flake = false;
  };
  inputs.plugins-orgroam-nvim = {
    url = "github:chipsenkbeil/org-roam.nvim";
    flake = false;
  };
  inputs.plugins-org-bullets = {
    url = "github:nvim-orgmode/org-bullets.nvim";
    flake = false;
  };
  inputs.grammars-org = {
    url = "github:nvim-orgmode/tree-sitter-org/next";
    flake = false;
  };
  outputs =
    { self
    , nixpkgs
    , wrappers
    , ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
      module = nixpkgs.lib.modules.importApply ./. inputs;
      wrapper = wrappers.lib.evalModule module;
    in
    {
      wrappers = {
        neovim = wrapper.config;
        default = self.wrappers.neovim;
      };
      overlays = {
        neovim = final: prev: { neovim = self.wrappers.neovim.wrap { pkgs = final; }; };
        default = self.overlays.neovim;
      };
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          neovim = self.wrappers.neovim.wrap { inherit pkgs; };
        in
        {
          neovim = neovim;
          default = neovim;
        }
      );

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          neovim = self.wrappers.neovim.wrap { inherit pkgs; };
        in
        {
          default = import ./shell.nix { inherit pkgs neovim; };
        });

      nixosModules = {
        default = self.nixosModules.neovim;
        neovim = wrappers.lib.getInstallModule {
          name = "neovim";
          value = module;
        };
      };

      homeModules = {
        default = self.homeModules.neovim;
        # they produce generically importable modules
        neovim = self.nixosModules.neovim;
      };
    };
}
