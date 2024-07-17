{ outputs, lib, ... }:
let 
  userOpts = { pkgs, name, config, ... }: {
    imports = (outputs.lib.readSubModulesAsList ./.);

    options = {};

    config = with lib; mkMerge
      [{ name = mkDefault name; }];
  };
in
{

  options = with lib; {
    preset.user = mkOption {
      default = {};
      type = with types; attrsOf (submodule userOpts);
      example = {
        yukkop.enable = true;
      };
      description = ''
        precreated user modules
      '';
    };
  };

  config = {
    preset.user.yukkop.enable = true;
  };
}
