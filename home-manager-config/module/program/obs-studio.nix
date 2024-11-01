{ pkgs, lib, config, ... }: 
let
  cfg = config.preset.program.obs-studio;
in
{
  options = {
    preset.program.obs-studio = {
      enable =
        lib.mkEnableOption "enable obs-studio";
      persistence =
        lib.mkEnableOption "enable persistence for obs-studio data";
    };
  };

  config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        obs-studio
      ];
  
      home.persistence."/persist/home/${user}" = 
        lib.mkIf config.preset.impermanence 
      {
        directories = [
          ".config/obs-studio"
        ];
        allowOther = true;
      };
  };
}
