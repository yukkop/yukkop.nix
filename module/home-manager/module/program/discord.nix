user: { pkgs, lib, config,  ... }: 
let
  cfg = config.preset.user."${user}".program.discord;
in
{
  options = {
    preset.user."${user}".program.discord = {
      enable =
        lib.mkEnableOption "enable discord";
    };
  };
 
  config = 
    lib.mkIf cfg.enable
  {
    home-manager.users."${user}" = 
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
  };
}
