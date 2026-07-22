{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) getExe';

  wrappedAstroLS = pkgs.symlinkJoin {
    name = "astro-language-server-wrapped";
    paths = [ pkgs.astro-language-server ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/astro-ls \
        --set NODE_PATH "${pkgs.typescript}/lib/node_modules"
    '';
  };

  inherit (lib.generators) mkLuaInline;
in
{
  enable = true;

  nixpkgs.config.allowUnfree = true;

  extraPackages = with pkgs; [
    qt6.qtdeclarative
    qt6.qttools
  ];

  colorschemes.poimandres = {
    enable = true;
    settings = {
      disable_background = true;
      disable_float_background = true;
    };
  };

  keymaps = [
    {
      action = "<cmd>Format<CR>";
      key = "<leader>f";
      options = {
        silent = true;
        noremap = true;
        desc = "Format";
      };
      mode = [ "n" ];
    }
    {
      action = "<cmd>w<CR>";
      key = "<leader>w";
      options = {
        silent = true;
        noremap = true;
        desc = "Save";
      };
      mode = [ "n" ];
    }
  ];

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "todo-nvim";
      version = "unstable";
      src = pkgs.fetchFromGitea {
        domain = "codeberg.org";
        owner = "smeikx";
        repo = "todo.nvim";
        rev = "4125555878f6e64c27fc4b1f63eae6c67f45bc6c";
        hash = "sha256-/UVKkkRxpfg3MQeLMRBJmVjRsltYGquEVOB8Qw6EO6c=";
      };
    })
    (pkgs.vimUtils.buildVimPlugin rec {
      pname = "neominimap-nvim";
      version = "3.16.0";
      src = pkgs.fetchFromGitHub {
        owner = "Isrothy";
        repo = "neominimap.nvim";
        tag = "v${version}";
        hash = "sha256-EcV/mdleyopQsJ/t/Whl6Yf/2ORb9rnhHuc2Ue1E1Bw=";
      };
    })
  ];

  extraConfigLua = ''
    vim.g.neominimap = {
      click = { enabled = true }
    };

    vim.keymap.set({'n', 'v', 's', 'o'}, '<MiddleMouse>', '<Nop>', { silent = true })
    vim.keymap.set('i', '<MiddleMouse>', '<Nop>', { silent = true }) 

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
      end,
    })

    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      update_in_insert = true,
      underline = true,
      severity_sort = false,
      float = true,
    })

    vim.filetype.add({
      extension = {
        art = "html"
      },
    })

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
  '';

  lsp = {
    inlayHints.enable = true;
    servers = {
      nil_ls = {
        enable = true;
        config = {
          nix.flake = {
            autoArchive = true;
            autoEvalInputs = true;
            nixpkgsInputName = "nixpkgs";
          };
        };
      };
      superhtml.enable = true;
      cssls.enable = true;
      ts_ls = {
        enable = true;
        config = {
          root_markers = [ "package.json" ];
        };
      };
      astro = {
        enable = true;
        package = wrappedAstroLS;
        config = {
          init_options.typescript.tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
        };
      };
      svelte.enable = true;
      marksman.enable = true;
      denols.enable = true;
      jsonls.enable = true;
      ty.enable = true;
      ruff.enable = true;
      qmlls = {
        enable = true;
        config.cmd = [
          "${getExe' pkgs.qt6.qtdeclarative "qmlls"}"
          "-E"
          "-I"
          "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
        ];
      };
      gopls.enable = true;
    };
  };

  plugins = {
    # editor
    treesitter = {
      enable = true;
      settings = {
        indent.enable = true;
        highlight.enable = true;
      };
      grammarPackages = with config.plugins.treesitter.package.parsers; [
        json
        typescript
        nix
        javascript
        java
        markdown
        markdown_inline
        svelte
        ini
        css
        scss
        zsh
        bash
        lua
        gitignore
        gitcommit
        gitattributes
        git_rebase
        git_config
        astro
        tsx
        csv
        just
        make
        xml
        html
        yaml
        toml
        kdl
        ssh_config
        robots_txt
        xresources
        python
        requirements
        rasi
        qmljs
        go
      ];
    };
    mini-hipatterns = {
      enable = true;
      luaConfig.content = ''
        local hipatterns = require('mini.hipatterns')
        hipatterns.setup({
          highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
            hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
            todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
            note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },

            -- Highlight hex color strings (`#rrggbb`) using that color
            hex_color = hipatterns.gen_highlighter.hex_color(),
          },
        })
      '';
    };
    gitsigns.enable = true;
    friendly-snippets.enable = true;
    nvim-tree.enable = true;
    which-key = {
      enable = true;
    };

    # qol
    mini-pairs.enable = true;
    mini-surround.enable = true;
    markview.enable = true;
    mini-trailspace.enable = true;
    mini-cursorword.enable = true;
    indent-blankline = {
      enable = true;
      settings = {
        indent.char = "│";
        scope = {
          enabled = true;
          show_start = true;
          show_end = false;
          highlight = [
            "Function"
            "Label"
          ];
        };
      };
    };

    # lsp
    lspconfig = {
      enable = true;
      autoLoad = true;
      lazyLoad.enable = false;
    };
    conform-nvim.enable = true;
    ts-autotag.enable = true;
    fidget.enable = true;
    trouble.enable = true;

    # ui
    lualine.enable = true;
    web-devicons.enable = true;
    bufferline.enable = true;
    blink-cmp = {
      enable = true;
      settings = {
        keymap.preset = "super-tab";

        appearance.nerd_font_variant = "normal";

        completion.documentation.auto_show = true;

        sources.default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];

        cmdline = {
          keymap.preset = "inherit";

          completion.menu.auto_show = mkLuaInline ''
            function(ctx)
              return vim.fn.getcmdtype() == ":"
              -- enable for inputs as well, with:
              -- or vim.fn.getcmdtype() == '@'
            end
          '';
        };

        fuzzy.implementation = "prefer_rust_with_warning";
      };
    };

    # misc
    cord.enable = true;
  };

  opts = {
    termguicolors = true;
    number = true;
    wrap = false;
    tabstop = 2;
    smartindent = true;
    shiftwidth = 2;
    expandtab = true;
    cursorline = true;
    cursorcolumn = true;
  };

  globals = {
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;

    mapleader = " ";
    maplocalleader = " ";
  };
}
