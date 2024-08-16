{ lib, pkgs, outputs, config, nixosModules, configType, ... }@args: 
{
  imports = [
    nixosModules.environment.module
  ];

  options = with lib; { };
  
  config = with lib; mkMerge [
    {
      preset = {
        impermanence = mkDefault true;
        graphics = mkDefault true;
        program.zsh.enable = true;
        windowManager.hyprland.enable = config.preset.graphics;
      };

      environment.systemPackages = [ pkgs.shellcheck ];

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
    (mkIf config.preset.impermanence {
        fileSystems."/persist".neededForBoot = true;
        environment.persistence."/persist/system" = {
          hideMounts = true;
          directories = [
            "/etc/nixos"
            "/etc/ssh"
            "/var/log"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/etc/NetworkManager/systemd-connections"
            { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
          ];
          files = [
            "/etc/machine-id"
            #{ file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
          ];
        };
    })
    ( if configType != "nix-on-droid" then {
      users.defaultUserShell = pkgs.zsh;
      nix = {
        settings = {
          # Enable flakes and new 'nix' command
          experimental-features = "nix-command flakes";

          # Deduplicate and optimize nix store
          auto-optimise-store = true;
        };
      };
    } else {})
  ];
}
