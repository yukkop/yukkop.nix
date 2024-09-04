{ pkgs, lib, config, nixosModules, outputs, ... }@args: 
let
  cfg = config.preset.program.ncdu;
in
{
  options = with lib; {
    preset.program.ncdu = {
      enable =
        mkEnableOption "enable ncdu";
    };
  };

  config = lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        ncdu
      ];
  };
}

