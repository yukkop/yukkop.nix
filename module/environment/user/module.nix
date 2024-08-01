{ outputs, lib, ... }:
{
  #imports = (outputs.lib.readSubModulesAsList ./user);

  #options = with lib; {};

  #config = { 
  #  preset.user.yukkop.enable = true;
  #};
}
