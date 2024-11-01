{ outputs, lib, ... }:
{
  imports = (outputs.lib.readSubModulesAsList ./.);

  options = with lib; {};

  config = {
  };
}
