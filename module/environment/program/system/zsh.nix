{ config, lib, nixosModules, outputs, ... }@args:
let
  cfg = config.preset.program.zsh;
in
{
  options = {
    preset.program.zsh = {
      enable =
        lib.mkEnableOption "enable steam";
      config = lib.mkOption {
        type = lib.types.anything;
	default = nixosModules.environment.program.config.zsh.common;
	apply = x: if lib.isFunction x then x else if lib.isAttrs x then x else throw "${cfg}.config must be a function or a attrs";
        description = ''
	  zsh config attributes or fuction that return its
        '';
      };
    };
  };

  /*  */
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.zsh = {
        enable = true;
        shellAliases = {};
      };


      home-manager.users.root = {
        home.stateVersion = "24.05";
      
        programs.zsh = outputs.lib.evaluateAttrOrFunction cfg.config args;
      };
    }
    (lib.mkIf config.preset.impermanence {
      home-manager.users.root.environment.persistence."/persist/system" = 
      {
        hideMounts = true;
        directories = [
          "/root/.zsh"
        ];
      };
    })
  ]);
}
