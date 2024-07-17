{ outputs, inputs, lib, ... }:
{
  imports = (outputs.lib.readSubModulesAsList ./.) ++ (with inputs; [ 
    home-manager.nixosModules.default
    impermanence.nixosModules.impermanence
  ]);

  options = {
   preset.impermanence = lib.mkEnableOption "enable impermanence on system";
  };
}
