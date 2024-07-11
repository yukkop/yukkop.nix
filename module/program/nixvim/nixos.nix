{ lib, config, inputs, flakeRoot, ...}:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.nixvim.nixosModules.nixvim
    flakeRoot.nixosModules.program.nixvim.default
  ];

  options = {
    module.program.nixvim = {
      persistence =
        lib.mkEnableOption "enable persistence for nixvim config";
    };
  };

  # TODO: take out this to funktion and use for both homeManagerModules.nixvim and modules.nixvim
  config = lib.mkIf config.module.program.nixvim.enable {
   ## impermamence
   environment.persistence."/persist/system" = 
     lib.mkIf config.module.program.nixvim.persistence
   {
     hideMounts = true;
     directories = [
       "/root/nvim/treesitter"
     ];
   };
  };
}
