{ lib, config, inputs, nixosModules, ...}:
let 
  cfg = config.preset.program;
in
{
  #  SAFETY: neccessary imports
  #  inputs.impermanence.nixosModules.impermanence
  imports = [
    inputs.nixvim.nixosModules.nixvim
    nixosModules.environment.program.config.nixvim.common
  ];

  options = {
    preset.program.nixvim = {
      enable =
        lib.mkEnableOption "enable nixvim";
    };
  };

  config = lib.mkIf config.module.program.nixvim.enable {
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
