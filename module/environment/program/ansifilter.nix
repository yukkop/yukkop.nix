{ lib, config, pkgs, ...}:
let 
  cfg = config.preset.program.ansifilter;
in
{
  options = {
    preset.program.ansifilter = {
      enable =
        lib.mkEnableOption "enable ansifilter";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ansifilter ];
    preset.shellAliases = { bleach = "ansifilter"; };
  };
}
