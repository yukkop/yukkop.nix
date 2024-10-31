user: { outputs, ... }:
{
  imports = (outputs.lib.readSubModulesAsListWithArgs ./. user);

  options = {};

  config = {};
}
