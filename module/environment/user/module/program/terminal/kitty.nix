user: { pkgs, lib, config, ... }: 
let
  cfg = config.preset.user."${user}".program.terminal.kitty;
in
{
  options = {
    preset.user."${user}".program.terminal.kitty = {
      enable =
        lib.mkEnableOption "enable kitty";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."${user}" = {
      home.packages = with pkgs; [ kitty ];
      home.persistence."/persist/home/${user}" = 
        lib.mkIf config.preset.impermanence 
      {
        directories = [ ];
        files = [ ];
        allowOther = true; 
      };
    };
  };
}
