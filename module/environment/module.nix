{ outputs, inputs, ... }:
{
  imports = (outputs.lib.readSubModulesAsList ./.) ++ [ inputs.home-manager.nixosModules.default ];
}
