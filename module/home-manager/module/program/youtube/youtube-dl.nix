user: { pkgs, lib, config, ... }:
let
  cfg = config.preset.user."${user}".program.youtube-dl;
in
{
  /* utility for download content from youtube */
  options = {
    preset.user."${user}".program.youtube-dl = {
      enable =
        lib.mkEnableOption "enable youtube-dl";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."${user}" = {
      home.packages = with pkgs; [
        youtube-dl
      ];
    };
  };
}
