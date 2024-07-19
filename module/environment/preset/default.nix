{ lib, pkgs, outputs, config, nixosModules, ... }@args: 
{
  imports = [
    nixosModules.environment.module
  ];

  options = with lib; { };
  
  config = with lib; mkMerge [
    {
      preset.impermanence = mkDefault true;

      preset.graphics = mkDefault true;

      preset.windowManager.hyprland.enable = config.preset.graphics;

      users.defaultUserShell = pkgs.zsh;

      preset.program.zsh.enable = true;

      nix = {
        settings = {
          # Enable flakes and new 'nix' command
          experimental-features = "nix-command flakes";

          # Deduplicate and optimize nix store
          auto-optimise-store = true;
        };
      };

    }
    ( mkIf config.preset.impermanence {
      fileSystems."/persist".neededForBoot = true;
      environment.persistence."/persist/system" = {
        hideMounts = true;
        directories = [
          "/etc/nixos"
          "/etc/ssh"
          "/var/log"
          "/var/lib/bluetooth"
          # TODO: check if this is exist
          #"/var/lib/nixos"
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
  ];
}
