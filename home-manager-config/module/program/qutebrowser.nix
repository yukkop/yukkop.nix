{ pkgs, lib, config, ... }: 
let
  cfg = config.preset.program.qutebrowser;
in
{
  options = {
    preset.program.qutebrowser = {
      enable =
        lib.mkEnableOption "enable qutebrowser";
      wayland =
        lib.mkEnableOption "preferences neccessary if you use wayland";
    };
  };

  config = lib.mkIf cfg.enable {
      programs.qutebrowser = {
        enable = true;
	settings = {
	  webengine = {
            qt.qpa.platform = lib.mkIf cfg.wayland "wayland";
	  };
	  editor.command = ["kitty" "-e" "nvim" "+{line}" "{file}" "+\\\"normal {column0}|\\\""];
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
}
