{ pkgs, lib, config, ... }:
let
  cfg = config.preset.program.yt-dlp;
in
{
  /* utility for download content from youtube */
  options = {
    preset.program.yt-dlp = {
      enable =
        lib.mkEnableOption "enable yt-dlp";
    };
  };

  config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        yt-dlp
      ];
  };
}
