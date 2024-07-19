user: { pkgs, lib, config, ... }: {
  /* utility for download content from youtube */
  options = {
    module.program.youtube-dl = {
      enable =
        lib.mkEnableOption "enable youtube-dl";
    };
  };

  config = lib.mkIf config.module.program.youtube-dl.enable {
    home-manager.users."${user}" = {
      home.packages = with pkgs; [
        youtube-dl
      ];
    };
  };
}
