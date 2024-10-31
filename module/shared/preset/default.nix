{ lib, pkgs, outputs, config, ... }@args: 
{
  options = with lib; { };
  
  config = with lib; mkMerge [
    {
      preset = {
        impermanence = mkDefault true;
        graphics = mkDefault true;
        program.zsh.enable = true;
        windowManager.hyprland.enable = config.preset.graphics;
      };

#FIXME: meh nix on droid
      #environment.systemPackages = [ pkgs.shellcheck ];

      virtualisation.docker.enable = true;
    }
    # utilities
    {
      preset = {
        program.ansifilter.enable = true;
        shellAliases = {
          nix-bleachlog = "
            __nix-bleachlog() {\
              if ! command -v ansifilter > /dev/null 2>&1; then\
                printobstacle \"Required tool (ansifilter) are not installed.\"\
                exit 1\
              fi\
              if [ -n \"$2\" ]; then\
                echo \"error: unexpected argument '$2'\n Try 'nix --help' for more information.\"\
              else\
              nix log $1 | ansifilter\
            }\
            __nix-bleachlog $@\
          ";
        };
      };
    }
  ];
}
