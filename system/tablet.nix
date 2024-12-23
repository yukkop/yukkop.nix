# configuration for nix-on-droid
{ config, lib, pkgs, ... }@args:
let 
  trace = builtins.traceVerbose;
  replaceFunctions = obj: 
    if builtins.isFunction obj then
      "function"
    else if builtins.isAttrs obj then
      builtins.mapAttrs (key: value: replaceFunctions value) obj
    else if builtins.isList obj then
      builtins.map replaceFunctions obj
    else
      obj;
in
{
  imports = [ ];
  
  environment.packages = trace (replaceFunctions args) (with pkgs; [ vim ]);
   
  #home-manager.config = trace (replaceFunctions args) {};
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
