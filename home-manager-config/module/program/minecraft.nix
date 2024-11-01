{ pkgs, lib, config, ... }: 
let
  cfg = config.preset.program.minecraft;
in
{
  options = {
    preset.program.minecraft = {
      enable =
        lib.mkEnableOption "enable minecraft";
      persistence =
        lib.mkEnableOption "enable persistence for minecraft config";
    };
  };

  config = lib.mkIf cfg.enable {
      home.packages = with pkgs;
      [
        # TODO: some overlay with config
        prismlauncher
        openjdk
        (lowPrio openjdk8) # `lowPrio` prevent simlink colision with `openjdk` 
        (lowPrio openjdk17)
      ];

      home.persistence."/persist/home/${user}" = 
        lib.mkIf config.preset.impermanence 
      {
        directories = [
          ".local/share/PrismLauncher/"
        ];
        allowOther = true;
      };
  };
}
