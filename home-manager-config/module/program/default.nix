user: { outputs, pkgs, ... }@args:
{
  imports = (outputs.lib.readSubModulesAsList ./.);

  options = {};

  config = {};
}
