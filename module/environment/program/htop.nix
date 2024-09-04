{ pkgs, lib, config, nixosModules, outputs, ... }@args: 
let
  cfg = config.preset.program.htop;
in
{
  options = with lib; {
    preset.program.htop = {
      enable =
        mkEnableOption "enable htop";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.htop = {
      enable = true;
      package = pkgs.htop-vim;
    };
  };
}
