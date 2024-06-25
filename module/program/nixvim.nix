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
    plugins = {
      oil.enable = true;
      lsp = {
        enable = true;
        servers = { 
          rust-analyzer = { 
	    enable = true;
	    installRustc = false;
	    installCargo = false;
	  };
        };
      };
    };
  };
}
