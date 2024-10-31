{ outputs, lib, flakeRootPath, ... }:
{
  imports = [
    "${flakeRootPath}/module/shared/preset/default.nix"
  ] ++ (outputs.lib.readSubModulesAsListWithArgs ./user ./module);

  options = with lib; {};

  config = { 
    preset.graphics = false;
    preset.user.yukkop.enable = true;
  };
}
