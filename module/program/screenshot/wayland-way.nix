{ pkgs, lib, config, ... }: {
  /*
    command to make a screenshot
    provide it to display manager module
  */
  options = {
    module.program.screenshoter = {
      callCommand = "grim -g \"''$(slurp)\" - | swappy -f";
      enable =
        lib.mkEnableOption "enable screenshoter";
    };
  };

  config = lib.mkIf config.module.program.screenshoter.enable {
    home.packages = with pkgs; [
      grim
      slurp
      swappy
    ];
  };
}
