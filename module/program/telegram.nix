 userName: { pkgs, lib, config, ... }: {
  options = {
    module.program.telegram = {
      enable =
        lib.mkEnableOption "enable mpv";
      persistence =
        lib.mkEnableOption "enable persistence for mpv config";
    };
  };

  config = lib.mkIf config.module.program.telegram.enable {
    home-manager.users."${userName}" = {
      home.packages = with pkgs; [
  	telegram-desktop
      ];
  
      home.persistence."/persist/home/${userName}" = 
        lib.mkIf config.module.program.telegram.persistence 
      {
        directories = [
  	  ".local/share/TelegramDesktop"
        ];
        allowOther = true;
      };
    };
  };
}
