{ outputs, lib, ... }:
{
  imports = (outputs.lib.readSubModulesAsList ./.);

  options = with lib; {};

  config = {
    preset.graphics = lib.mkForce false;
    preset.impermanence = lib.mkDefault false;
  };
}
