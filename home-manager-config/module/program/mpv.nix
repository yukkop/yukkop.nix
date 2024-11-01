{ pkgs, lib, config, ... }:
let
  userCfg = config.preset;
  cfg = userCfg.program.mpv;
in
{
  options = {
    preset.program.mpv = {
      enable =
        lib.mkEnableOption "enable mpv";
      persistence =
        lib.mkEnableOption "enable persistence for mpv config";
    };
  };

  config = lib.mkIf cfg.enable {
    # FIXME: home manager related module in nixos modules
    # preset.shellAliases = {
    #   mpvf = "mpv --osd-msg1='\${estimated-frame-number} / \${estimated-frame-count}'";
    # };

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
}
