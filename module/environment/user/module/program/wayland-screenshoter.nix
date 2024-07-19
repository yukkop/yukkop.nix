user: { pkgs, lib, config, ... }: 
let
  cfg = config.preset.user."${user}".program.screenshoter.grim;
in
{
  options = {
    preset.user."${user}".program.screenshoter.grim = {
      callCommand = "grim -g \"''$(slurp)\" - | swappy -f";
      enable =
        lib.mkEnableOption "enable screenshoter";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."${user}" = {
      home.packages = with pkgs; [
        grim
        slurp
        swappy
      ];
    };
  };
}
