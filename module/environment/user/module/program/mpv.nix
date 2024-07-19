user: { pkgs, lib, config, ... }:
let
  userCfg = config.preset.user."${user}";
  cfg = userCfg.program.mpv;
in
{
  options = {
    preset.user."${user}".program.mpv = {
      enable =
        lib.mkEnableOption "enable mpv";
      persistence =
        lib.mkEnableOption "enable persistence for mpv config";
    };
  };

  config = lib.mkIf cfg.enable {
    preset.user."${user}".shellAliases = {
      mpvf = "mpv --osd-msg1='\${estimated-frame-number} / \${estimated-frame-count}'";
    };

    home-manager.users."${user}" = {
      home.packages = with pkgs; [
        mpv
      ];
  
      home.persistence."/persist/home/${user}" = 
        lib.mkIf config.preset.impermanence 
      {

        directories = [
          ".config/mpv"
        ];
        allowOther = true;
      };
    };
  };
}
