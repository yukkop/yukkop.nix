{ pkgs, ... }:

{
  enable = true;
  colorschemes.kanagawa = {
    enable = true;
    settings = {
    colors.theme = {
      all = {
        ui = {
          #bg_gutter = "none";
          #bg = "none";
        };
        #float = {
        #  bg = "none";
        #};
      };
    };
    #background = {
    #  light = null;
    #  dark = null;
    #};
    };
  };
  #colorschemes.nightfox.enable = true;
  # 
  extraConfigVim = ''
  '';
  extraConfigLuaPre = ''
    vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
    vim.g.mapleader = ' '
  '';
  keymaps = [
    {
      mode = "n";
      key = "<leader>dd";
      #options.silent = true;
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
    }
    {
      mode = "n";
      key = "<leader>dn";
      action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
    }
    {
      mode = "n";
      key = "<leader>dp";
      action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
    }
  ];
  extraPlugins = 
    (with pkgs.vimPlugins; [
      nvim-treesitter-parsers.templ
      vim-shellcheck
      vim-grammarous
      #nvim-metals # scala lsp
    ]) ++
    (with pkgs; [ postgres-lsp ]);
  plugins = {
    # loading spin for lsp server
    fidget.enable = true;
    # vim way directory redactor
    oil.enable = true;
    # allow use zsh history in nvim
    #cmp-zsh = true;
    treesitter = {
      enable = true;
      #settings = {
      #  auto_install = false;
      #  ensure_installed = [
      #    "all"
      #  ];
      #  highlight = {
      #    additional_vim_regex_highlighting = true;
      #    custom_captures = { };
      #    disable = [ ];
      #    enable = true;
      #  };
      #  ignore_install = [ ];
      #  incremental_selection = {
      #    enable = true;
      #    keymaps = {
      #      init_selection = "<leader>gnn";
      #      node_decremental = "<leader>grm";
      #      node_incremental = "<leader>grn";
      #      scope_incremental = "<leader>grc";
      #    };
      #  };
      #  indent = {
      #    enable = true;
      #  };
      #  parser_install_dir = "$XDG_DATA_HOME/nvim/treesitter";
      #  sync_install = false;
      #};
    };
    lsp = {
      enable = true;
      keymaps.lspBuf = {
        "<leader>lh" = "hover";
        "<leader>ld" = "definition";
        "<leader>lD" = "references";
        "<leader>lr" = "rename";
        "<leader>li" = "implementation";
        "<leader>lt" = "type_definition";
        "<leader>lf" = "format";
        "<leader>la" = "code_action";
      };
      servers = { 
        /* Rust */
        rust-analyzer = { 
          enable = true;
          installRustc = false;
          installCargo = false;
        };
        /* Nix */
        /* unmaintaned */
        #rnix-lsp = {
        #  enable = true;
        #  autostart = true;
        #  package = "";
        #};
        /* strange hover without any usefull information */
        nixd = {
          enable = true;
          /* no visible effect */
          # https://nix-community.github.io/nixd/md_nixd_2docs_2configuration.html
          # tyajelo
          #extraOptions = {
          #  nixpkgs = {
          #     expr = "import <nixpkgs> { }";
          #  };
          #  formatting = {
          #     command = "nixpkgs-fmt";
          #  };
          #  options = {
          #     nixos = {
          #        expr = "(builtins.getFlake (\"git+file://\" + toString ./.)).nixosConfigurations.k-on.options";
          #     };
          #     home_manager = {
          #        expr = "(builtins.getFlake (\"git+file://\" + toString ./.)).homeConfigurations.\"ruixi@k-on\".options";
          #     };
          #  };
          #};
        };
        nil-ls = {
          enable = true;
          extraOptions = {
            formatting = { command = ["nixpkgs-fmt"]; };
          };
        };
        /* C / C++ */
        clangd.enable = true;
        /* TS, JS */
        tsserver.enable = true;
	/* GO */
	gopls.enable = true;
	templ.enable = true;
	/* SHELL */
	bashls.enable = true;
	/* KOTLIN */
        kotlin-language-server.enable = true;
	/* SCALA */
        metals = {
	  enable = true;
	  cmd = ["metals"];
	};
	/* SQL */
	sqls.enable = true;
	/* JAVA */
	java-language-server.enable = true;
	/* PYTHON */
	pylsp.enable = true;
      };
    };
  };
}
