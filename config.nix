{
  pkgs,
  config,
  ...
}: {
  config = {
    colorschemes.tokyonight = {
      style = "night";
      enable = true;
    };

    options = {
      termguicolors = true;
      number = true;
      tabstop = 4;
      shiftwidth = 4;
      scrolloff = 7;
      signcolumn = "yes";
      cmdheight = 2;
      cot = ["menu" "menuone" "noselect"];
      updatetime = 100;
      colorcolumn = "100";
      spell = true;
    };

    commands = {
      "SpellFr" = "setlocal spelllang=fr";
    };

    filetype = {
      enable = true;

      literal = {
        Jenkinsfile = "groovy";
      };
      extensions = {
        nix = "nix";
        rsh = "rsh";
        lalrpop = "lalrpop";
      };
    };

    lua_keymaps = let
      nrsilent = rhs: {
        rhs = rhs;
        opts = {
          remap = false;
          silent = true;
        };
      };
    in {
      n = {
        "ft" = nrsilent "<cmd>NvimTreeToggle<CR>";

        "bp" = nrsilent "<cmd>Telescope buffers<CR>";

        "<C-s>" = nrsilent "<cmd>Telescope spell_suggest<CR>";
        "mk" = nrsilent "<cmd>Telescope keymaps<CR>";
        "fg" = nrsilent "<cmd>Telescope git_files<CR>";

        "gr" = nrsilent "<cmd>Telescope lsp_references<CR>";
        "gI" = nrsilent "<cmd>Telescope lsp_implementations<CR>";
        "gW" = nrsilent "<cmd>Telescope lsp_workspace_symbols<CR>";
        "gF" = nrsilent "<cmd>Telescope lsp_document_symbols<CR>";
        "ge" = nrsilent "<cmd>Telescope diagnostics bufnr=0<CR>";
        "gE" = nrsilent "<cmd>Telescope diagnostics<CR>";
        "ca" = nrsilent "<cmd>lua vim.lsp.buf.code_action()<CR>";
        "ff" = nrsilent "<cmd>lua vim.lsp.buf.format()<CR>";
        "K" = nrsilent "<cmd>lua vim.lsp.buf.hover()<CR>";

        "<leader>rn" = {
          rhs = ''
            function()
            	return ":IncRename " .. vim.fn.expand("<cword>")
            end
          '';
          lua = true;
          opts = {expr = true;};
        };
      };
    };

    plugins = {
      osc52.enable = true;
      null-ls = {
        enable = true;
        sources = {
          diagnostics = {
            shellcheck.enable = true;
            cppcheck.enable = true;
            gitlint.enable = true;
          };
          code_actions = {
            shellcheck.enable = true;
            #gitsigns.enable = true;
          };
          formatting = {
            alejandra.enable = true;
            black.enable = true;
            stylua.enable = true;
            cbfmt.enable = true;
            shfmt.enable = true;
            taplo.enable = true;
            prettier.enable = true;
          };
        };
      };
      gitsigns.enable = true;
      gitmessenger.enable = true;

      firenvim.enable = true;

      nvim-cmp = {
        enable = true;

        snippet = {
          expand = ''
            function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end
          '';
        };

        mapping = {
          "<CR>" = "cmp.mapping.confirm({select = true })";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<Tab>" = ''cmp.mapping(cmp.mapping.select_next_item(), {"i", "s"})'';
          "<Down>" = "cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'})";
          "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'})";
        };

        sources = [
          {name = "path";}
          {name = "buffer";}
          {name = "vsnip";}
          {name = "nvim_lsp";}
          {name = "calc";}
        ];
      };

      telescope = {
        enable = true;
        enabledExtensions = ["ui-select"];
        extensionConfig = {
          ui-select = {
            __raw = ''
                require("telescope.themes").get_dropdown {
                -- even more opts
              }
            '';
          };
        };
      };

      treesitter = {
        enable = true;
        indent = true;

        grammarPackages = with config.plugins.treesitter.package.passthru.builtGrammars; [
          bash
          c
          html
          help
          latex
          lua
          nix
          python
          rust
          arduino
          cpp
          cuda
          dart
          devicetree
          diff
          dockerfile
          git_rebase
          gitattributes
          gitcommit
          gitignore
          ini
          json
          lalrpop
          make
          markdown
          markdown_inline
          meson
          ninja
          rst
          slint
          sql
          tlaplus
          toml
          yaml
        ];
      };

      treesitter-refactor = {
        enable = true;
        highlightDefinitions = {
          enable = true;
          clearOnCursorMove = true;
        };
        smartRename = {
          enable = true;
        };
        navigation = {
          enable = true;
        };
      };

      treesitter-context = {
        enable = true;
      };

      vim-matchup = {
        treesitterIntegration = {
          enable = true;
          includeMatchWords = true;
        };
        enable = true;
      };
      editorconfig.enable = true;
      headerguard.enable = true;

      comment-nvim = {
        enable = true;
      };

      nvim-tree = {
        enable = true;

        diagnostics.enable = true;
        git.enable = true;
      };

      plantuml-syntax.enable = true;

      indent-blankline = {
        enable = true;

        useTreesitter = true;

        showCurrentContext = true;
        showCurrentContextStart = true;
      };

      lsp = {
        enable = true;

        servers = {
          nil_ls = {
            enable = true;
            settings = {
              formatting.command = ["alejandra" "--quiet"];
            };
          };
          bashls.enable = true;
		  dartls.enable = true;
        };
      };

      rust-tools = {
        enable = true;
        inlayHints = {
          maxLenAlign = true;
        };

        server = {
          cargo.features = "all";
          checkOnSave = {
            enable = true;
            command = "clippy";
          };
        };
      };

      lspkind = {
        enable = true;
        cmp = {
          enable = true;
        };
      };

      nvim-lightbulb = {
        enable = true;
        autocmd.enabled = true;
      };

      lsp_signature = {
        #enable = true;
      };

      inc-rename = {
        enable = true;
      };

      clangd-extensions = {
        enable = true;
        enableOffsetEncodingWorkaround = true;

        extensions.ast = {
          roleIcons = {
            type = "";
            declaration = "";
            expression = "";
            specifier = "";
            statement = "";
            templateArgument = "";
          };
          kindIcons = {
            compound = "";
            recovery = "";
            translationUnit = "";
            packExpansion = "";
            templateTypeParm = "";
            templateTemplateParm = "";
            templateParamObject = "";
          };
        };
      };

      # fidget = {
      #   enable = true;
      #
      #   sources.null-ls.ignore = true;
      # };

      lualine = {
        enable = true;
      };

      trouble = {
        enable = true;
      };

      noice = {
        enable = true;

        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = true;
          lsp_doc_border = false;
        };
      };
    };

    extraConfigVim = ''
      if exists('g:started_by_firenvim')
        nnoremap <C-S-v> "+p
        NoiceDisable
      endif
    '';

    extraPlugins = with pkgs.vimPlugins; [
      telescope-ui-select-nvim
      vim-vsnip
      markdown-preview-nvim
    ];
  };
}
