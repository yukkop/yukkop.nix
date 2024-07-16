{ config, lib, flakeRoot, inputs, ... }: {
  #  neccessary imports
  #  inputs.impermanence.nixosModules.impermanence
 
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
     directories = [
       "/root/.zsh"
     ];
   };

    home-manager.users.root = {
          home.stateVersion = "24.05";

	  imports = [
            (flakeRoot.nixosModules.program.home-manager.zsh {})
	  ];

          programs.zsh = {
            enable = true;
          };
        };
      };
}
