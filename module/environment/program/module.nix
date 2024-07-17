{ outputs, config, lib, ... }:
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

  config = {
    preset.program = lib.mkIf cfg.defaultConfig {
      zsh.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      nixvim.enable = lib.mkDefault true;
    };

    # disable default not strictly necessary packages - nano, perl, etc
    environment.defaultPackages = lib.mkIf (!cfg.defaultPackages) [];
  };
}
