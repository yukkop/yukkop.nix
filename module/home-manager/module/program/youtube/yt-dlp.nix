user: { pkgs, lib, config, ... }:
let
  cfg = config.preset.user."${user}".program.yt-dlp;
in
{
  /* utility for download content from youtube */
  options = {
    preset.user."${user}".program.yt-dlp = {
      enable =
        lib.mkEnableOption "enable yt-dlp";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."${user}" = {
      home.packages = with pkgs; [
        yt-dlp
      ];
    };
  };
}
