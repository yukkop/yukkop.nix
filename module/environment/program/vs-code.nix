{ pkgs, lib, config, nixosModules, outputs, ... }@args: 
let
  cfg = config.preset.program.tmux;
in
{
  options = with lib; {
    preset.program.tmux = {
      enable =
        mkEnableOption "enable tmux";
      config = mkOption {
        type = types.anything;
        default = nixosModules.environment.common.program.tmux.default;
        apply = x: if isFunction x then x else if isAttrs x then x else throw "${cfg}.config must be a function or a attrs";
        description = ''
          nixvim config attributes or fuction that return its
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    programs.tmux = outputs.lib.evaluateAttrOrFunction cfg.config args;
  };
}
