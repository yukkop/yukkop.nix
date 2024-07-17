{ config, lib, inputs, ... }: {
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
  config = lib.mkIf config.module.program.zsh.enable (lib.mkMerge [
    {
      programs.zsh = {
        enable = true;
        shellAliases = {};
      };


      home-manager.users.root = {
        home.stateVersion = "24.05";
      
        imports = [
	  #TODO
        ];
      
        programs.zsh = {
          enable = true;
        };
      };
    }
    (lib.mkIf config.module.program.zsh.persistence {
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
