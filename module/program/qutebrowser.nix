# TODO userNameS
userName: { pkgs, lib, config, ... }: {
  /* module for home-manager */

  options = {
    programs.qutebrowser.enable =
      lib.mkEnableOption "enable qutebrowser";
    programs.qutebrowser.persistence =
      lib.mkEnableOption "enable persistence for qutebrowser data";
  };

  config = lib.mkIf config.programs.qutebrowser.enable {
    home-manager.users."${userName}" = {
      home.packages = with pkgs; [
        qutebrowser
      ];

      home.persistence."/persist/home/yukkop" = lib.mkIf config.programs.qutebrowser.persistence {
        directories = [
          ".config/qutebrowser"
          ".local/share/qutebrowser"
        ];
        allowOther = true; 
      };
    };
  };
}
