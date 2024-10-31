user: { outputs, pkgs, ... }@args:
{
  imports = (outputs.lib.readSubModulesAsListWithArgs ./. user);

  options = {};

  config = {};
}
