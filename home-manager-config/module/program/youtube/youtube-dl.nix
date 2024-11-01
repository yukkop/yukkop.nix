{ pkgs, lib, config, ... }:
let
  cfg = config.preset.program.youtube-dl;
in
{
  /* utility for download content from youtube */
  options = {
    preset.program.youtube-dl = {
      enable =
        lib.mkEnableOption "enable youtube-dl";
    };
  };

  config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        youtube-dl
      ];
  };
}
