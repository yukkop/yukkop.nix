{ outputs, ... }@args:
{
  imports = (outputs.lib.readSubModulesAsList ./user);

  options = {
  };

  config = {
  };
}
