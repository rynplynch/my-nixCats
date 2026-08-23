{ config
, wlib
, lib
, pkgs
, options
, ...
}:
{
  options.settings.general = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    neogit = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    oil = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    vimstart = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    telescope = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    moonfly-colors = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config.specs.neogit = {
    enable = if (config.settings.general.enable || config.settings.general.neogit) then true else false;
    # note we didn't have to specify the `lze` specs name, because it was a top level spec
    data = config.nvim-lib.neovimPlugins.neogit;
    config = ''
      -- UI for git
      vim.keymap.set("n", "<leader>-", "<cmd>Neogit<cr>", { desc = "Launch Neogit" })
    '';
  };

  config.specs.oil = {
    enable = if (config.settings.general.enable || config.settings.general.oil) then true else false;
    data = pkgs.vimPlugins.oil-nvim;
    config = ''
      require("oil").setup()
      vim.keymap.set("n", "-", "<cmd>Oil<CR>")
    '';
  };

  config.specs.vimstart = {
    enable = if (config.settings.general.enable || config.settings.general.vimstart) then true else false;
    # note we didn't have to specify the `lze` specs name, because it was a top level spec
    # lazy = true;
    data = with pkgs.vimPlugins; [
      vim-startuptime
    ];
    config = ''
      vim.g.startuptime_event_width = 0
      vim.g.startuptime_tries = 10
      vim.g.startuptime_exe_path = nixInfo(vim.v.progpath, "progpath")
    '';
  };

  config.specs.telescope = {
    enable = if (config.settings.general.enable || config.settings.general.telescope) then true else false;
    data = pkgs.vimPlugins.telescope-nvim;
    config = ''
      require("telescope").setup({
         defaults = {
            results_title = false,
            sorting_strategy = "ascending",
            layout_strategy = "vertical",
            layout_config = {
               preview_cutoff = 1, -- Preview should always show (unless previewer = false)
            },
         }
      })

      -- searching for files in project, keymaps, text in files and the help doc
      vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files)
      vim.keymap.set("n", "<leader>sF", function()
         require("telescope.builtin").find_files({ cwd = '~', hidden = true })
      end)
      vim.keymap.set("n", "<leader>sd", function()
         return require("telescope.builtin").find_files({ hidden = true })
      end)
      vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps)
      vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep)
      vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags)
    '';
    runtimePkgs = with pkgs; [
      ripgrep
    ];
  };

  config.specs.moonfly-colors = {
    enable = if (config.settings.general.enable || config.settings.general.moonfly-colors) then true else false;
    data = pkgs.vimPlugins.vim-moonfly-colors;
    config = ''
      vim.cmd [[colorscheme moonfly]]
    '';
  };
}
