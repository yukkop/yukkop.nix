{ outputs, inputs, lib, configType, ... }:
{
  imports = 
    (outputs.lib.readSubModulesAsList ./.) ++
    (with inputs; [ 
      impermanence.nixosModules.impermanence
    ]) ++
    (lib.optional (configType != "nix-on-droid") (inputs.home-manager.nixosModules.default));

  options = {
    preset = {
      enable = lib.mkEnableOption "enable defatult preset";
      graphics = lib.mkEnableOption "enable graphics"; 
      nix-on-droid = lib.mkEnableOption "enable nix-on-droid";
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
    environment.persistence = {
      type = lib.types.anything; 
      default = {};
      description = "";
    };
  };
}
