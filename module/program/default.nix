{ lib, config, flakeRoot, inputs, ... }:
{
    imports = (with flakeRoot.nixosModules.program; [
      hyprland.default
      tmux
      docker
      nixvim.nixos
      (zsh.nixos { shellAliases = config.module.program.shellAliases; })
    ]) ++ (with inputs; [
      impermanence.nixosModules.impermanence
    ]);

    options = {
     module.program.shellAliases = lib.mkOption {
       type = lib.types.attrs;
       default = {};
       description = "Shell alliases, would provide to all enable shell";
     };
    };

    config = { };
}
