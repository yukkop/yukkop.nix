# configuration for nix-on-droid
{ config, lib, pkgs, outputs, ... }:
{
  imports = [
    outputs.nixosModules.environment.preset.default
  ];

  #preset.impermanence = lib.mkForce false;
  #preset.graphics = lib.mkForce false;
  #preset.nix-on-droid = lib.mkForce true;
  #preset.user.yukkop.enable = lib.mkForce true;

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

