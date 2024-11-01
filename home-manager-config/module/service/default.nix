{ outputs, ... }:
{
  imports = (outputs.lib.readSubModulesAsList ./.);

  options = {};

  config = {};
}
