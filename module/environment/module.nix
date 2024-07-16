{ outputs, ... }:
{
  imports = (outputs.lib.readSubModulesAsList ./.);
}
