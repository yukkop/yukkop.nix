{ shellAliases ? {} }: { config, lib, flakeRoot, inputs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options = {
    module.program.zsh = {
      enable =
        lib.mkEnableOption "enable steam";
      persistence =
        lib.mkEnableOption "enable persistence for steam data";
    };
  };

  /*  */
  config = lib.mkIf config.module.program.zsh.enable {
   programs.zsh = {
     enable = true;
     shellAliases = shellAliases;
   };

   environment.persistence."/persist/system" = 
     lib.mkIf config.module.program.zsh.persistence
   {
     hideMounts = true;
     files = [
       "/root/zsh-history"
     ];
   };

    home-manager.users.root = {
          home.stateVersion = "24.05";

	  imports = [
            (flakeRoot.nixosModules.program.zsh.default {})
	  ];

          programs.zsh = {
            enable = true;
          };
        };
      };
}
