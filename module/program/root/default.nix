{ lib, config, flakeRoot, inputs, ... }:
{
    imports = (with flakeRoot.nixosModules.program.root; [
      hyprland
      tmux
      docker
      nixvim
      (zsh { shellAliases = config.module.program.shellAliases; })
    ]) ++ (with inputs; [
      impermanence.nixosModules.impermanence
    ]);

    options = {
     module.program = {
       defaultConfig = lib.mkOption {
         type = lib.types.bool;
         default = true;
         description = "enable default program config that yukkop prefer - zsh, tmux, nixvim etc";
         example = false;
       };

       # literaty useles, will anyone enable it?
       defaultPackages = 
         lib.mkEnableOption "enable default not strictly necessary packages - nano, perl, etc";

       shellAliases = lib.mkOption {
         type = lib.types.attrs;
         default = {};
         description = "Shell alliases, would provide to all enable shell";
         example = {
           tmux = "tmux a";
           ll = "ls -la";
         };
       };
     };
    };

    config = {
      module.program = lib.mkIf config.module.program.defaultConfig {
        tmux.enable = lib.mkDefault true;
        zsh.enable = lib.mkDefault true;
        nixvim.enable = lib.mkDefault true;
      };

      # disable default not strictly necessary packages - nano, perl, etc
      environment.defaultPackages = lib.mkIf (!config.module.program.defaultPackages) [];
    };
}
