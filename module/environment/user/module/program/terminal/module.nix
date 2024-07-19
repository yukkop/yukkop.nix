user: { outputs, ... }: {
  imports = (outputs.lib.readSubModulesAsListWithArgs ./. user);
}
