{ homeManager ? false, nixvim, ...}: {
  imports = [
    (
      if homeManager 
      then nixvim.homeManagerModules.nixvim 
      else nixvim.nixosModules.nixvim
    )   
  ];

  # TODO: take out this to funktion and use for both homeManagerModules.nixvim and modules.nixvim
  programs.nixvim = {
    enable = true;
    extraConfigLua = ''
      vim.g.mapleader = ' '
    '';
    plugins = {
      oil.enable = true;
      #keymaps = [
      #  {
      #    action = "<cmd>lua<CR>";
      #    key = "<C-m>";
      #    options = {
      #      silent = true;
      #    };
      #  }
      #];
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
	  nil_ls = {
	    enable = true;
	    extraOptions = {
              formatting = { command = ["nixpkgs-fmt"]; };
	    };
	  };
	  /* C */
	  clangd.enable = true;
        };
      };
    };
  };
}
