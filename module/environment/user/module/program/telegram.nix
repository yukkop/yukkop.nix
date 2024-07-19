user: { pkgs, lib, config, ... }: 
let
  userCfg = config.preset.user."${user}";
  cfg = "${userCfg}".program.telegram;
in
{
  options = {
    preset.user."${user}".program.telegram = {
      enable =
        lib.mkEnableOption "enable mpv";
      persistence =
        lib.mkEnableOption "enable persistence for mpv config";
    };
  };

  config = lib.mkIf cfg.enable {
    preset.user."${user}".shellAliases = {
      telegram = "telegram-desktop";
    };

    home-manager.users."${user}" = {
      home.packages = with pkgs; [
  	telegram-desktop
      ];
  
      home.persistence."/persist/home/${user}" = 
        lib.mkIf config.preset.impermanence 
      {
        directories = [
  	  ".local/share/TelegramDesktop"
        ];
        allowOther = true;
      };
    };
  };
}
