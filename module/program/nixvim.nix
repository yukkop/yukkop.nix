{ inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim   
  ];

  # TODO: take out this to funktion and use for both homeManagerModules.nixvim and modules.nixvim
  programs.nixvim = {
    enable = true;
    plugins = {
      oil.enable = true;
      lsp = {
        enable = true;
        servers = { 
          rust-analyzer.enable = true;
        };
      };
    };
    colorschemes.gruvbox.enable = true; 
  };
}
