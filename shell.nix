{ pkgs ? import <nixpkgs> { }
, nixCats
, self
, system
}:
with pkgs; let
  customNixCats =
    (self.packages.${system}.default.override (prev: {
      name = "neodev";
      categoryDefinitions = nixCats.utils.mergeCatDefs prev.categoryDefinitions ({ pkgs, settings, categories, name, extra, mkPlugin, ... }@packageDef: {
        optionalLuaAdditions = {
          nix-build-bypass =
            let
              newDir = "/home/ryanl/git-repos/my-nixCats";
            in
              /*lua*/''
              local newCfgDir = [[${newDir}]]
              vim.opt.packpath:prepend(newCfgDir)
              vim.opt.runtimepath:prepend(newCfgDir)
              vim.opt.runtimepath:append(newCfgDir .. "/after")
              if vim.fn.filereadable(newCfgDir .. "/init.vim") == 1 then
                vim.cmd.source(newCfgDir .. "/init.vim")
              end
              if vim.fn.filereadable(newCfgDir .. "/init.lua") == 1 then
                dofile(newCfgDir .. "/init.lua")
              end
            '';
        };
      });
      packageDefinitions = prev.packageDefinitions // {
        # the name here is what will show up in CLI
        neodev = nixCats.utils.mergeCatDefs prev.packageDefinitions.nvim ({ pkgs, ... }: {
          settings = {
            wrapRc = false;
          };
          categories = {
            general = false;
            lua-dev = false;
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
