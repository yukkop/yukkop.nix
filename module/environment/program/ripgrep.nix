{ pkgs, lib, config, nixosModules, outputs, ... }@args: 
let
  cfg = config.preset.program.ripgrep;
in
{
  options = with lib; {
    preset.program.ripgrep = {
      enable =
        mkEnableOption "enable ripgrep";
    };
  };

  config = lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        ripgrep
      ];
  };
}
