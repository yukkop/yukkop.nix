{ lib, pkgs, outputs, ... }@args: 
{
  imports = [

  ];
  options = with lib; {
    preset.enable = mkEnableOption "enable defatult preset";
    preset.name = mkOption {
      type = types.bool;
      default = true;
      #type = types.submodule programOpts.options;
      #default = programOpts.options;
      description = "aaaa";
    };
     # extraGroups = mkOption {
     #   type = types.listOf types.str;
     #   default = [];
     #   description = "The user's auxiliary groups.";
     # };

    #preset.user = ""; #import from folder
  };
  
  config = {
    #users.defaultUserShell = pkgs.zsh;

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
