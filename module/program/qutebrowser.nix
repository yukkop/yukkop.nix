# TODO userNameS
userName: { pkgs, lib, config, ... }: {
  /* module for home-manager */

  options = {
    module.program.qutebrowser = {
      enable =
        lib.mkEnableOption "enable qutebrowser";
      persistence =
        lib.mkEnableOption "enable persistence for qutebrowser data";
    };
  };

  config = lib.mkIf config.module.program.qutebrowser.enable {
    home-manager.users."${userName}" = {
      home.packages = with pkgs; [
        qutebrowser
      ];

      home.persistence."/persist/home/${userName}" = 
        lib.mkIf config.module.program.qutebrowser.persistence 
      {
        directories = [
          ".config/qutebrowser"
          ".local/share/qutebrowser"
        ];
        allowOther = true; 
      };
    };
  };
}
