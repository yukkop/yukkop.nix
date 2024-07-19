user: { pkgs, lib, config, ... }: 
let
  cfg = config.preset.user."${user}".program.qutebrowser;
in
{
  options = {
    preset.user."${user}".program.qutebrowser = {
      enable =
        lib.mkEnableOption "enable qutebrowser";
      persistence =
        lib.mkEnableOption "enable persistence for qutebrowser data";
      wayland =
        lib.mkEnableOption "preferences neccessary if you use wayland";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."${user}" = {
      programs.qutebrowser = {
        enable = true;
	settings = {
	  webengine = {
            qt.qpa.platform = lib.mkIf config.module.program.qutebrowser.wayland "wayland";
	  };
	};
      };

      home.persistence."/persist/home/${user}" = 
        lib.mkIf config.preset.impermanence 
      {
        directories = [
          #".config/qutebrowser"
          ".local/share/qutebrowser"
        ];
        allowOther = true; 
      };
    };
  };
}
