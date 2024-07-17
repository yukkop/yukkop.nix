{ lib, pkgs, outputs, config, nixosModules, ... }@args: 
{
  imports = [
    nixosModules.environment.module
  ];

  options = with lib; {
    preset.enable = mkEnableOption "enable defatult preset";
  };
  
  config = {
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
  };
}
