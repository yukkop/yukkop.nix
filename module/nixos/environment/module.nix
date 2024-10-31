{ outputs, inputs, lib, configType, ... }:
{
  imports = 
    (outputs.lib.readSubModulesAsList ./.)
    ++ (with inputs; [ 
      impermanence.nixosModules.impermanence
    ]) 
    ++ (lib.optional (configType != "nix-on-droid") (inputs.home-manager.nixosModules.default))
  ;

  options = 
    {
      preset = {
        enable = lib.mkEnableOption "enable defatult preset";
        graphics = lib.mkEnableOption "enable graphics"; 
        impermanence = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "enable impermanence on system";
          apply = x: 
            if (configType == "nix-on-droid" || configType == "nixos-wsl") && x then
              abort "not able to use preset.impermanence on nix-on-droid or in windows subsystem linux (WSL)"
            else
              x;
          example = true;
        };
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
    } //
    # TODO: maybe I need fix it
    # this is stupidies workarround that make ignore the errors
    ( if configType == "nix-on-droid" then {
      environment.systemPackages = lib.mkOption {};
      # FIXME: nixvim needs.. so it broke something?
      environment.variables = lib.mkOption {};
    } else {} );
}
