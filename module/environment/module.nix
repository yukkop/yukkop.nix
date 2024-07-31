{ outputs, inputs, lib, config, ... }:
{
  #imports = 
  #(outputs.lib.readSubModulesAsList ./.) ++ 
  #(with inputs; [ ]) ++ 
  #(if config.preset.nix-on-droid then with inputs; [
  #  # nix-on-droid have another interface for home manager
  #  home-manager.nixosModules.default
  #  impermanence.nixosModules.impermanence
  #] else []);

  options = {
    #preset = {
    #  enable = lib.mkEnableOption "enable defatult preset";
    #  graphics = lib.mkEnableOption "enable graphics"; 
    #  nix-on-droid = lib.mkOption {
    #    type = lib.types.bool;
    #    default = false;
    #    description = "enable if you use nix-on-droid instead regular nixos";
    #    example = true;
    #  };
    #  impermanence = lib.mkOption {
    #    type = lib.types.bool;
    #    default = false;
    #    description = "enable impermanence on system";
    #    apply = x: 
    #      if config.preset.nix-on-droid && x then
    #        abort "not able to use preset.impermanence with preset.nix-on-droid"
    #      else
    #        x;
    #    example = true;
    #  };
    #  shellAliases = lib.mkOption {
    #    type = with lib.types; attrsOf (nullOr (either str path));
    #    default = {};
    #    description = "Shell alliases, would provide to all enable shell";
    #    example = {
    #      tmux = "tmux a";
    #      ll = "ls -la";
    #    };
    #  };

    #};
  } //
  # this is bypass when some imports missing
  (if config.preset.nix-on-droid then {
    fileSystems = {
      type = lib.types.anything; 
      default = {};
      description = "";
    };
    environment.persistence = {
      type = lib.types.anything; 
      default = {};
      description = "";
    };
  } else {});
}
