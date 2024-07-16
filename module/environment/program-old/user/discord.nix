 { pkgs, lib, config, ... }: 
let
  userName = "zalupa";
in
 {
  options = {
    program.discord = {
      enable =
        lib.mkEnableOption "enable discord";
      persistence =
        lib.mkEnableOption "enable persistence for discord config";
    };
  };

  config = 
    lib.mkIf config.program.discord.enable
  {
    home-manager.users."${userName}" = 
    {
      home.packages = with pkgs; [
        discord
      ];

      home.persistence."/persist/home/${userName}" =
        lib.mkIf config.program.discord.persistence
      {
        directories = [
          ".config/discord"
        ];
        allowOther = true;
      };
    };
  };
}
