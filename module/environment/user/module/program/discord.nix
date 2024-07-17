{ pkgs, systemConfig, name, lib, config,  ... }: 
{
  options = {
    program.discord = {
      enable =
        lib.mkEnableOption "enable discord";
    };
  };
 
  config = 
    lib.mkIf config.program.discord.enable
  {
    home-manager.users."${name}" = 
    {
      home.packages = with pkgs; [
        discord
      ];
 
      home.persistence."/persist/home/${name}" =
        lib.mkIf systemConfig.preset.impermamence
      {
        directories = [
          ".config/discord"
        ];
        allowOther = true;
      };
    };
  };
}
