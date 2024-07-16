{ lib, config, outputs, inputs, ... }:
{
    options = {
     #module.program = {
     #  defaultConfig = lib.mkOption {
     #    type = lib.types.bool;
     #    default = true;
     #    description = "enable default program config that yukkop prefer - zsh, tmux, nixvim etc";
     #    example = false;
     #  };

       # literaty useles, will anyone enable it?
       defaultPackages = 
         lib.mkEnableOption "enable default not strictly necessary packages - nano, perl, etc";

     #  shellAliases = lib.mkOption {
     #    type = lib.types.attrs;
     #    default = {};
     #    description = "Shell alliases, would provide to all enable shell";
     #    example = {
     #      tmux = "tmux a";
     #      ll = "ls -la";
     #    };
     #  };
     #};
    };

    config = {
      # disable default not strictly necessary packages - nano, perl, etc
      #environment.defaultPackages = lib.mkIf (!config.options.module.program.defaultPackages) [];
    };
}
