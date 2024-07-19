user: { config, lib,  inputs, nixosModules, ... }: 
let
  cfg = config.preset.user."${user}".program.zsh;
in
{
  options = {
    preset.user."${user}".program.zsh = {
      enable =
        lib.mkEnableOption "enable steam";
      persistence =
        lib.mkEnableOption "enable persistence for steam data";
    };
  };

  /*  */
  config = lib.mkIf cfg.enable {
    home-manager = {
      users = {
        "${user}" = {
	  imports = [
            nixosModules.common.zsh.common
	  ];

          programs.zsh = {
            enable = true;
          };

          home.persistence."/persist/home/${user}" = 
            lib.mkIf config.preset.impermanence 
          {
            directories = [
              ".zsh"
            ];
            allowOther = true;
          };
        };
      };
    };
  };
}
