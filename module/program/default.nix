{ shellAliases ? {} }: { lib, config, flakeRoot, inputs, ... }:
{
    imports = (with flakeRoot.nixosModules.program; [
      hyprland.default
      tmux
      nixvim.nixos
      (zsh.nixos { shellAliases = shellAliases; })
    ]) ++ (with inputs; [
      impermanence.nixosModules.impermanence
    ]);

    options = { };

    config = { };
}
