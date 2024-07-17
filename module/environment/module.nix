{ outputs, inputs, lib, ... }:
{
  imports = (outputs.lib.readSubModulesAsList ./.) ++ (with inputs; [ 
    home-manager.nixosModules.default
    impermanence.nixosModules.impermanence
  ]);

  options = {
    preset = {
      impermanence = lib.mkEnableOption "enable impermanence on system";
      shellAliases = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Shell alliases, would provide to all enable shell";
        example = {
          tmux = "tmux a";
          ll = "ls -la";
        };
      };
    };
  };
}
