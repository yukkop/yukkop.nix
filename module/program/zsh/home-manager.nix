 userName: { shellAliases ? {} }: { config, lib, flakeRoot, inputs, ... }: {
  options = {
    module.home.user."${userName}".program.zsh = {
      enable =
        lib.mkEnableOption "enable steam";
      persistence =
        lib.mkEnableOption "enable persistence for steam data";
    };
  };

  /*  */
  config = lib.mkIf config.module.home.user."${userName}".program.zsh.enable {
    home-manager = {
      users = {
        "${userName}" = {
	  imports = [
            (flakeRoot.nixosModules.program.zsh.default shellAliases)
	  ];

          programs.zsh = {
            enable = true;
          };
        
          home.persistence."/persist/home/${userName}" = 
            lib.mkIf config.module.home.user."${userName}".program.zsh.persistence 
          {
            files = [
              "zsh-history"
            ];
            allowOther = true;
          };
        };
      };
    };
  };
}
