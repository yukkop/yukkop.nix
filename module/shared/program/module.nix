{ outputs, config, lib, inputs, configType, ... }:
let
  cfg = config.preset.program;
in
{
  imports = 
     with outputs.lib; (readSubModulesAsList ./.);

  options = {
     preset.program = {
       defaultConfig = lib.mkOption {
         type = lib.types.bool;
         default = true;
         description = "enable default program config that yukkop prefer - zsh, tmux, nixvim etc";
         example = false;
       };

       # literaty useles, will anyone enable it?
       defaultPackages = 
         lib.mkEnableOption "enable default not strictly necessary packages - nano, perl, etc";
     };
  };

  config = lib.mkMerge [
    # not exist in nix-on-droid

    #( lib.optionalAttrs (configType != "nix-on-droid") {
    #  # disable default not strictly necessary packages - nano, perl, etc
    #  environment.defaultPackages = lib.mkIf (!cfg.defaultPackages) [];
    #} )
    ( if configType != "nix-on-droid" then {
      # disable default not strictly necessary packages - nano, perl, etc
      environment.defaultPackages = lib.mkIf (!cfg.defaultPackages) [];
    } else {} )
    {
      preset.program = lib.mkIf cfg.defaultConfig {
        zsh.enable = lib.mkDefault true;
        tmux.enable = lib.mkDefault true;
        htop.enable = lib.mkDefault true;
        nixvim.enable = lib.mkDefault true;
        zoxide.enable = lib.mkDefault true;

        ripgrep.enable = lib.mkDefault false;
        ncdu.enable = lib.mkDefault false;
      };

      home-manager.users.root = {
        imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

        home.stateVersion = "24.05";
      };
    }
  ];
}
