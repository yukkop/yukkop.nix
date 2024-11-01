# configuration for nix-on-droid
{ config, lib, pkgs, outputs, ... }@args:
{
  imports = [ ];
   
  home-manager.config = outputs.homeManagerConfigs.yukkop;

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = "Europe/Rome";
}

