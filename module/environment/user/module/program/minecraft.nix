user: { pkgs, lib, config, ... }: 
let
  cfg = config.preset.user."${user}".program.minecraft;
in
{
  options = {
    preset.user."${user}".program.minecraft = {
      enable =
        lib.mkEnableOption "enable minecraft";
      persistence =
        lib.mkEnableOption "enable persistence for minecraft config";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."${user}" = {
      home.packages = with pkgs;
      [
        # TODO: some overlay with config
        prismlauncher
        openjdk
        (lowPrio openjdk8) # `lowPrio` prevent simlink colision with `openjdk` 
        (lowPrio openjdk17)
      ];

      home.persistence."/persist/home/${user}" = 
        lib.mkIf config.impermamence 
      {
        directories = [
          ".local/share/PrismLauncher/"
        ];
        allowOther = true;
      };
    };
  };
}
