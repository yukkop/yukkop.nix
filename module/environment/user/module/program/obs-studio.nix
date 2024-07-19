user: { pkgs, lib, config, ... }: 
let
  cfg = config.preset.user."${user}".program.obs-studio;
in
{
  options = {
    preset.user."${user}".prorgam.obs-studio = {
      enable =
        lib.mkEnableOption "enable obs-studio";
      persistence =
        lib.mkEnableOption "enable persistence for obs-studio data";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."${user}" = {
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
  };
}
