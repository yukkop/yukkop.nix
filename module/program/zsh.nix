 userName: shellAliases: { pkgs, config, lib, ... }: {
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

    home-manager = {
      users = {
        "${userName}" = {

          programs.zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
          
          shellAliases = shellAliases;
            history = {
              size = 10000;
              path = "$HOME/zsh-history";
            };
            oh-my-zsh = {
              enable = true;
              #plugins = [ "git" "thefuck" ];
              #theme = "fox";
              #theme = "imajes";
              theme = "terminalparty";
              #theme = "itchy"
              #theme = "kardan"
              #theme = "nicoulaj"
            };
          };
        
          home.persistence."/persist/home/${userName}" = 
            lib.mkIf config.module.program.steam.persistence 
          {
            directories = [
              "zsh-history"
            ];
            allowOther = true;
          };
        };
      };
    };
  };
}
