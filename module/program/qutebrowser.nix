# TODO userNameS
userName: { pkgs, lib, config, ... }: {
  /* module for home-manager */

  options = {
    module.program.qutebrowser = {
      enable =
        lib.mkEnableOption "enable qutebrowser";
      persistence =
        lib.mkEnableOption "enable persistence for qutebrowser data";
      wayland =
        lib.mkEnableOption "preferences neccessary if you use wayland";
    };
  };

  config = lib.mkIf config.module.program.qutebrowser.enable {
    home-manager.users."${userName}" = {
      programs.qutebrowser = {
        enable = true;
	settings = {
	  webengine = {
            qt.qpa.platform = lib.mkIf config.module.program.qutebrowser.wayland "wayland";
	  };
	};
      };

      home.persistence."/persist/home/${userName}" = 
        lib.mkIf config.module.program.qutebrowser.persistence 
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
