{ lib, pkgs, outputs, config, ... }@args: 
{
  options = 
    {
      preset = {
        enable = lib.mkEnableOption "enable defatult preset";
        graphics = lib.mkEnableOption "enable graphics"; 
        impermanence = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "enable impermanence on system";
          #apply = x: 
          #  if (configType == "nix-on-droid" || configType == "nixos-wsl") && x then
          #    abort "not able to use preset.impermanence on nix-on-droid or in windows subsystem linux (WSL)"
          #  else
          #    x;
          example = true;
        };
        shellAliases = lib.mkOption {
          type = with lib.types; attrsOf (nullOr (either str path));
          default = {};
          description = "Shell alliases, would provide to all enable shell";
          example = {
            tmux = "tmux a";
            ll = "ls -la";
          };
        };
      };
    };
  
  config = with lib; mkMerge [
    {
      preset = {
        impermanence = mkDefault true;
        graphics = mkDefault true;
	# TODO: add
        #program.zsh.enable = true;
        #windowManager.hyprland.enable = config.preset.graphics;
      };

      # FIXME: meh nix on droid
      #environment.systemPackages = [ pkgs.shellcheck ];

      # REFACTOR: docker on android not very posible 
      #virtualisation.docker.enable = true;
    }
    # utilities
    {
      preset = {
        # TODO: add
        #program.ansifilter.enable = true;
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
