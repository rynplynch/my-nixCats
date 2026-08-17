{ config
, wlib
, lib
, pkgs
, options
, ...
}:
{
  config.specs.lsp = {
    data = null;
    config = ''
      -- shared configuration for all language servers
      -- listen for 'LspAttach' event, execute this before server attaches
      vim.api.nvim_create_autocmd('LspAttach', {
         -- creating a new group for the auto commands
         group = vim.api.nvim_create_augroup('my.lsp', {}),
         -- callback function that gets called with arguments about the starting server
         callback = function(args)
            -- get the ls client object
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

            -- check if the language server has formatting functionality
            if client:supports_method('textDocument/formatting') then
               -- Every time we write the buffer
               vim.api.nvim_create_autocmd('BufWritePre', {
                  -- set group equal to the one we created above
                  group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                  -- set buffer so we only format the current buffer
                  buffer = args.buf,
                  callback = function()
                     -- ask the ls to format the current buffer
                     vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                  end,
               })
            else
               print("The language server does not support formatting " .. client.id)
            end
            if client:supports_method('textDocument/completion') then
               vim.lsp.completion.enable(true, client.id, args.buf, {
                  autotrigger = true,
                  convert = function(item)
                     return { abbr = item.label:gsub('%b()', "") }
                  end
               })
            else
               print("The language server does not support completion " .. client.id)
            end
         end,
      })
    '';
  };

  # You can use the before and after fields to run them before or after other specs or spec of lists of specs
  config.specs.lua = {
    # after = [ "lsp" ];
    data = null;
    # data = with pkgs.vimPlugins; [
    #   lazydev-nvim
    # ];
    runtimePkgs = with pkgs; [
      lua-language-server
      stylua
    ];
    config = ''
      vim.lsp.config['lua_ls'] = {
        -- Command and arguments to start the server.
        cmd = { 'lua-language-server' },
        -- Filetypes to automatically attach to.
        filetypes = { 'lua' },
        -- Sets the "workspace" to the directory where any of these files is found.
        -- Files that share a root directory will reuse the LSP server connection.
        -- Nested lists indicate equal priority, see |vim.lsp.Config|.
        root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
        -- Specific settings to send to the server. The schema is server-defined.
        -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            }
          }
        }
      }

       vim.lsp.enable('lua_ls')
    '';
  };

  config.specs.nix = {
    # mainInfo.nixdExtras = {
    #   nixpkgs = "import ${builtins.path { path = pkgs.path; }} {}";
    #   # get_configs = lib.generators.mkLuaInline # lua
    #   # ''function(type, path) return [[import ${./nixd.nix} "${pkgs.stdenv.hostPlatform.system}" "]] .. type .. [[" ]] .. (path or "./.") end'';
    # };
    config = ''
       -- configure nix grammar for treesitter
       -- vim.cmd.packadd("nvim-treesitter-grammar-nix")
       -- local grammar_path = nixCats.pawsible('allPlugins.opt.nvim-treesitter-grammar-nix')
       -- vim.treesitter.language.add('nix', { path = grammar_path .. '/parser/nix.so' })
       -- vim.treesitter.language.register('nix', { 'nix' })

       vim.lsp.config('nil_ls', {
        -- Command and arguments to start the server.
        cmd = { 'nil' },
        -- Filetypes to automatically attach to.
        filetypes = { 'nix' },
        -- Sets the "workspace" to the directory where any of these files is found.
        -- Files that share a root directory will reuse the LSP server connection.
        -- Nested lists indicate equal priority, see |vim.lsp.Config|.
        root_markers = { { 'default.nix', 'flake.nix' }, '.git' },
          settings = {
             ['nil'] = {
                formatting = {
                   -- tell nil_ls what command to use when formatting
                   command = { "nixpkgs-fmt" }
                }
             }
          }
      })

       vim.lsp.enable('nil_ls')
    '';
    data = with pkgs; [
      vimPlugins.nvim-treesitter-parsers.nix
    ];
    runtimePkgs = with pkgs; [
      nil
      nixpkgs-fmt
    ];
  };

  config.specs.orgmode = {
    data = with config.nvim-lib.neovimPlugins; [
      # { data = orgmode; }
      orgmode
      # org-grammar
      orgroam-nvim
      org-bullets
      config.nvim-lib.grammars.org
    ];
    config = ''
      require('orgmode').setup({
         org_agenda_files = { '~/orgfiles/**/*', '~/org_roam_files/daily/' },
         org_default_notes_file = '~/orgfiles/refile.org',
         win_split_mode = { 'float' }
      })

      vim.lsp.enable('org')

      require("org-roam").setup({
         directory = "~/org_roam_files",
         -- optional
         org_files = {
            '~/orgfiles/**/*'
         }
      })

      require('org-bullets').setup()

      -- -- configure blink to allow for orgmode auto completion
      -- local blink = require("blink-cmp")
      -- blink.add_source_provider("orgmode", {
      --    name = 'Orgmode',
      --    module = 'orgmode.org.autocompletion.blink',
      --    fallbacks = { 'buffer' },
      -- })

      -- blink.add_filetype_source("org", "orgmode")
    '';
  };
}
