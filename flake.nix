{
  description = "Flake exporting a configured neovim package";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
  inputs.wrappers.inputs.nixpkgs.follows = "nixpkgs";
  # Demo on fetching plugins from outside nixpkgs
  inputs.plugins-lze = {
    url = "github:BirdeeHub/lze";
    flake = false;
  };
  # These 2 are already in nixpkgs, however this ensures you always fetch the most up to date version!
  inputs.plugins-lzextras = {
    url = "github:BirdeeHub/lzextras";
    flake = false;
  };
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
      #module = nixpkgs.lib.modules.importApply ./nix inputs;
      module = nixpkgs.lib.modules.importApply ./nix inputs;
      wrapper = wrappers.lib.evalModule module;
    in
    # for demonstration purposes, we will set up all the outputs.
    {
      wrapperModules = {
        # neovim = module;
        neovim = {
          imports = [ (import ./nix inputs) ];
          # I will deal with this next time I have to do python.# lsp and stuff breaks all the time, driving me nuts
          # config.specs.python = _: { enable = false; };
          # disable roc for now because I haven't been using it# and it builds the lsp from source which is slow
          # config.specs.roc = _: { enable = false; };
        };
        default = self.wrapperModules.neovim;
      };
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
      # home manager and nixos modules
      # `wrappers.neovim.enable = true`
      # You can set any of the options.
      # But that is how you enable it.
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
