{ pkgs, lib, config, ... }: 
let
  cfg = config.preset.program.terminal.kitty;
in
{
  options = {
    preset.program.terminal.kitty = {
      enable =
        lib.mkEnableOption "enable kitty";
    };
  };

  config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [ kitty ];
      home.persistence."/persist/home/${user}" = 
        lib.mkIf config.preset.impermanence 
      {
        directories = [ ];
        files = [ ];
        allowOther = true; 
      };
  };
}
