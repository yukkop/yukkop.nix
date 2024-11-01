{ pkgs, lib, config,  ... }: 
let
  cfg = config.preset.program.discord;
in
{
  options = {
    preset.program.discord = {
      enable =
        lib.mkEnableOption "enable discord";
    };
  };
 
  config = 
    lib.mkIf cfg.enable
  {
      home.packages = with pkgs; [
        discord
      ];
 
      home.persistence."/persist/home/${user}" =
        lib.mkIf config.preset.impermanence
      {
        directories = [
          ".config/discord"
        ];
        allowOther = true;
      };
  };
}
