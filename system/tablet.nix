# configuration for nix-on-droid
{ config, lib, pkgs, outputs, inputs, ... }@args:
{
  imports = [ outputs.core ];
  
  environment.packages = with pkgs; [ vim ];
   
  home-manager.config = outputs.homeManagerConfigs.yukkop;
  #home-manager.config = { config, ... }: {
  #  imports = [
  #      #inputs.impermanence.nixosModules.home-manager.impermanence
  #  ];
  #  	
  #  options = {
  #    cfg = lib.mkOption {
  #      type = with lib.types; attrsOf (nullOr (either str path));
  #      default = {};
  #      description = "Shell alliases, would provide to all enable shell";
  #      example = {
  #        tmux = "tmux a";
  #        ll = "ls -la";
  #      };
  #    };
  #  }; 
  #  config = {
  #    cfg = config.system.stateVersion;
  #    home.stateVersion = "24.05";
  #  };
  #};

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
