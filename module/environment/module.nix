{ outputs, inputs, lib, ... }:
{
  imports = (outputs.lib.readSubModulesAsList ./.) ++ (with inputs; [ 
    home-manager.nixosModules.default
    impermanence.nixosModules.impermanence
  ]);

  options = {
    preset = {
      enable = lib.mkEnableOption "enable defatult preset";
      graphics = lib.mkEnableOption "enable graphics"; 
      impermanence = lib.mkEnableOption "enable impermanence on system";
      shellAliases = lib.mkOption {
        type = with lib.types; attrsOf (nullOr (either str path));
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
