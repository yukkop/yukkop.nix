{ pkgs, lib, config, ... }: 
let
  cfg = config.preset.program.screenshoter.grim;
in
{
  options = {
    preset.program.screenshoter.grim = {
      callCommand = "grim -g \"''$(slurp)\" - | swappy -f";
      enable =
        lib.mkEnableOption "enable screenshoter";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      slurp
      swappy
    ];
  };
}
