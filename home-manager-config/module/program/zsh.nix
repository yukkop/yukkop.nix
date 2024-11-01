{ config, lib,  outputs, nixosModules, ... }@args: 
let
  userCfg = config;
  cfg = userCfg.program.zsh;
in
{
  options = {
    preset.program.zsh = {
      enable =
        lib.mkEnableOption "enable steam";
      persistence =
        lib.mkEnableOption "enable persistence for steam data";
      config = lib.mkOption {
        type = lib.types.anything;
	default = nixosModules.environment.common.program.zsh.default;
	apply = x: if lib.isFunction x then x else if lib.isAttrs x then x else throw "${cfg}.config must be a function or a attrs";
        description = ''
	  zsh config attributes or fuction that return its
        '';
      };
    };
  };

  /*  */
  config = lib.mkIf cfg.enable {
	  imports = [
	  ];

          programs.zsh = (outputs.lib.evaluateAttrOrFunction cfg.config args) // { shellAliases = userCfg.shellAliases; };

          home.persistence."/persist/home/${user}" = 
            lib.mkIf config.preset.impermanence 
          {
            directories = [
              ".zsh"
            ];
            allowOther = true;
          };
        };
}
