shellAliases: { config, lib, ... }: {
  options = { };

  /*  */
  config = {

          programs.zsh = {
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
          
            shellAliases = shellAliases;
            history = {
              size = 10000;
              path = "$HOME/.zsh/.zsh_history";
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
        };
}
